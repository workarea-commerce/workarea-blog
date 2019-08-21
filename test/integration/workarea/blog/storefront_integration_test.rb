require 'test_helper'

module Workarea
  module Blog
    class StorefrontIntegrationTest < Workarea::IntegrationTest
      include Storefront::IntegrationTest

      setup :user
      setup :blog

      def user
        @user ||= create_user(
          email:    'test@workarea.com',
          password: 'w3bl1nc',
          name:     'Ben Crouse'
        )
      end

      def login_user
        post storefront.login_path,
             params: {
               email:    user.email,
               password: 'w3bl1nc'
             }
      end

      def blog
        @blog ||= create_blog(
          name: 'Test',
          slug: 'test',
          entries: [
            { name: 'Entry 1', author: 'BC1' },
            { name: 'Entry 2', author: 'BC2' }
          ]
        )
      end

      def test_can_show_an_atom_feed_of_the_blog
        get storefront.blog_path(@blog, format: 'atom')

        assert_includes(response.body, 'Entry 1')
        assert_includes(response.body, 'BC1')
        assert_includes(response.body, 'Entry 2')
        assert_includes(response.body, 'BC2')
      end

      def test_can_create_a_comment_when_logged_in
        login_user

        entry = @blog.entries.first
        post storefront.blog_entry_comment_path(entry), params: { body: 'test comment' }

        assert_equal(1, entry.comments.count)
        assert_equal(@user.id.to_s, entry.comments.first.user_id)
        assert_equal('test comment', entry.comments.first.body)
        assert(entry.comments.first.user_info.present?)
        refute(entry.comments.first.approved?)
      end

      def test_updates_a_users_names
        login_user
        entry = @blog.entries.first

        @user.update_attributes(first_name: nil, last_name: nil)

        post storefront.blog_entry_comment_path(entry), params: {
          body: 'test comment',
          first_name: 'Foo',
          last_name: 'Bar'
        }

        @user.reload
        assert_equal('Foo', @user.first_name)
        assert_equal('Bar', @user.last_name)
      end

      def test_raises_invalid_display_unless_the_entry_is_active
        entry = @blog.entries.first

        entry.update_attributes!(active: false)
        assert_raises(InvalidDisplay) { get storefront.blog_entry_path(entry) }
      end

      def test_showing_content_on_blog_show
        blog_content = Workarea::Content.for(blog)
        blog_content.blocks.build(
          area: :header_content,
          type: :text,
          data: { text: 'Test blog content' }
        )
        blog_content.save!

        get storefront.blog_path(blog)
        assert(response.body.include?('Test blog content'))
      end

      def test_uses_thumbnail_for_og_image
        entry = @blog.entries.first
        asset = create_asset
        get storefront.blog_entry_path(entry)

        assert_select 'meta[property="og:image"]', false

        entry.update!(thumbnail_image: asset.id.to_s)
        get storefront.blog_entry_path(entry)
        view_model = Workarea::Storefront::BlogEntryViewModel.wrap(entry)

        assert_select 'meta[property="og:image"]', true, content: view_model.thumbnail_image_url
      end
    end
  end
end
