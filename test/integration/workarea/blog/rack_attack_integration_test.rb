require 'test_helper'

module Workarea
  class Blog::RackAttackIntegrationTest < Workarea::IntegrationTest
    class AddEnvMiddleware
      def initialize(app)
        @app = app
      end

      def call(env)
        env.merge!(Rails.application.env_config)
        @app.call(env)
      end
    end

    def test_prevent_comment_spam
      ip = '192.168.1.1'
      user = create_user
      blog_entry = create_blog_entry(blog: create_blog)
      key = [ip, user.id.to_s].reject(&:blank?).join(':')
      env = { 'HTTP_COOKIE' => "user_id=#{user.id}", 'REMOTE_ADDR' => ip }

      post "/blog_entries/#{blog_entry.slug}/comment", env: env

      assert_response(:success)

      Rack::Attack::Allow2Ban.stubs(:banned?).returns(false)
      Rack::Attack::Allow2Ban.stubs(:banned?).with(key).returns(true)

      post "/blog_entries/#{blog_entry.slug}/comment", env: env

      assert_equal('blog/comments', request.env['rack.attack.matched'])
      assert_equal(:blocklist, request.env['rack.attack.match_type'])
      assert_response(:forbidden)
    end

    private

    def app
      @app ||= begin
        Rack::Builder.new do
          use AddEnvMiddleware
          use Rack::Attack
          use ActionDispatch::Cookies
          run -> (*) { [ 200, {}, [] ] }
        end
      end
    end
  end
end
