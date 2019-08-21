require 'test_helper'

module Workarea
  module Blog
    class AdminIntegrationTest < Workarea::IntegrationTest
      include Admin::IntegrationTest

      def test_searches_blogs
        create_blog(name: 'Foo Blog')
        get admin.content_blogs_path(format: 'json', q: 'foo')
        results = JSON.parse(response.body)['results']
        assert_equal(1, results.length)
      end

      def test_responds_to_edit_paths
        blog = create_blog(
          name: 'Test Blog',
          entries: [
            { name: 'Test Entry', author: 'BC' }
          ]
        )

        get admin.edit_polymorphic_path(blog)
        assert(response.ok?)

        get admin.edit_polymorphic_path(blog.entries.first)
        assert(response.ok?)
      end

      def test_has_blogs
        blog = create_blog(
          name: 'Test Blog',
          entries: [
            { name: 'Test Entry', author: 'BC' }
          ]
        )

        get admin.jump_to_path, params: { q: 'te' }

        results = JSON.parse(response.body)['results']
        assert_equal(2, results.length)

        assert_equal('Test Blog', results.first['label'])
        assert_equal('Blogs', results.first['type'])
        assert_equal(admin.content_blog_path(blog), results.first['url'])

        blog.destroy

        get admin.jump_to_path, params: { q: 'te' }
        results = JSON.parse(response.body)['results']
        assert_equal(0, results.length)
      end
    end
  end
end
