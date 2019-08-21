require 'test_helper'

module Workarea
  module Storefront
    class BlogSystemTest < Workarea::SystemTest
      include Storefront::SystemTest

      setup :blog
      setup :set_entries_on_index
      teardown :unset_entries_on_index

      def blog
        @blog ||= create_blog(
          entries: [
            { name: 'Entry 1', author: 'Ben Crouse', summary: 'A short summary about the entry' },
            { name: 'Entry 2', author: 'Ben Crouse', summary: 'A different summary for this entry' }
          ]
        )
      end

      def set_entries_on_index
        @blog_entries_on_index = Workarea.config.blog_entries_on_index
        Workarea.config.blog_entries_on_index = 4
      end

      def unset_entries_on_index
        Workarea.config.blog_entries_on_index = @blog_entries_on_index
      end

      def test_display
        visit storefront.blog_path(blog)

        assert(page.has_content?('Entry 1'))
        assert(page.has_content?('A short summary about the entry'))
        assert(page.has_content?('Entry 2'))
        assert(page.has_content?('A different summary for this entry'))

        entry_content = Workarea::Content.for(blog.entries.first)
        entry_content.blocks.build(
          area: :blog_content,
          type: :text,
          data: { text: 'Body' }
        )
        entry_content.save!

        click_link 'Entry 1'

        assert(page.has_current_path?(storefront.blog_entry_path(blog.entries.first)))
        assert(page.has_content?('Entry 1'))
        assert(page.has_content?('Body'))
      end

      def test_blog_index
        create_blog(
          entries: [
            {
              name: 'Entry 1',
              author: 'Ben Crouse',
              summary: 'A short summary about the entry',
              written_at: Time.now - 1.day
            },
            {
              name: 'Entry 2',
              author: 'Ben Crouse',
              summary: 'A different summary for this entry',
              written_at: Time.now - 2.day
            },
            {
              name: 'Entry 3',
              author: 'Ben Crouse',
              summary: 'This is the third post',
              written_at: Time.now - 3.day
            },
            {
              name: 'Entry 4',
              author: 'Ben Crouse',
              summary: 'This post should not be shown on index',
              written_at: Time.now - 4.day
            },
            {
              name: 'Entry 5',
              author: 'Ben Crouse',
              summary: 'This post is featured and should show first',
              written_at: Time.now - 5.day,
              featured: true
            }
          ]
        )

        visit storefront.blogs_path

        assert(page.has_content?('Test Blog'))

        assert(page.has_content?('Entry 5'))
        assert(page.has_content?('This post is featured and should show first'))
        assert(page.has_content?('Entry 1'))
        assert(page.has_content?('A short summary about the entry'))
        assert(page.has_content?('Entry 2'))
        assert(page.has_content?('A different summary for this entry'))
        assert(page.has_content?('Entry 3'))
        assert(page.has_content?('This is the third post'))

        assert(page.has_no_content?('Entry 4'))
        assert(page.has_no_content?('And this is the fourth post'))
      end

      def test_tags
        blog = create_blog(
          entries: [
            { name: 'Entry 1', author: 'Ben Crouse' },
            { name: 'Entry 2', author: 'Ben Crouse', tag_list: 'foo,bar' }
          ]
        )

        visit storefront.blog_path(blog)

        assert(page.has_content?('foo (1)'))
        assert(page.has_content?('bar (1)'))

        click_link 'foo (1)'

        assert(page.has_content?('Entry 2'))
        assert(page.has_no_content?('Entry 1'))

        visit storefront.blog_entry_path(blog.entries.first)

        assert(page.has_content?('foo (1)'))
        assert(page.has_content?('bar (1)'))
      end

      def test_related_products
        create_product(
          name: 'Related Product',
          id: 'product_1',
          variants: [
            { sku: 'SKU1', regular: 10.to_m },
            { sku: 'SKU2', regular: 20.to_m }
          ]
        )

        blog = create_blog(
          entries: [
            { name: 'Entry 2', author: 'Ben Crouse', product_ids: ['product_1'] }
          ]
        )

        visit storefront.blog_entry_path(blog.entries.first)

        assert(page.has_content?(/Related Product/i))
      end

      def test_comments
        blog = create_blog(
          entries: [
            { name: 'Entry 1', author: 'Ben Crouse' }
          ]
        )

        create_user(email: 'test@workarea.com', password: 'w3bl1nc', name: 'Ben Crouse')
        visit storefront.login_path

        within '#login_form' do
          fill_in 'email', with: 'test@workarea.com'
          fill_in 'password', with: 'w3bl1nc'
          click_button 'login'
        end

        visit storefront.blog_entry_path(blog.entries.first)
        fill_in 'body', with: 'test comment'
        click_button 'submit_comment'

        assert_equal(storefront.blog_entry_path(blog.entries.first), current_path)
        assert(page.has_content?('Success'))

        Workarea::Content::BlogComment.first.update_attributes(approved: true)

        clear_driver_cache if respond_to?(:clear_driver_cache)
        visit storefront.blog_entry_path(blog.entries.first)
        assert(page.has_content?('test comment'))

        assert(page.has_content?('1 Comment'))

        visit storefront.blog_entry_path(blog.entries.first)
        fill_in 'body', with: 'test comment 2'
        click_button 'submit_comment'

        assert_equal(storefront.blog_entry_path(blog.entries.first), current_path)
        assert(page.has_content?('Success'))

        Workarea::Content::BlogComment
          .where(body: 'test comment 2')
          .first
          .update_attributes!(approved: true)

        clear_driver_cache if respond_to?(:clear_driver_cache)
        visit storefront.blog_entry_path(blog.entries.first)

        assert(page.has_content?('test comment 2'))
        assert(page.has_content?('2 Comments'))

        Workarea::Content::BlogComment
          .where(body: 'test comment')
          .first
          .destroy

        clear_driver_cache if respond_to?(:clear_driver_cache)
        visit storefront.blog_entry_path(blog.entries.first)
        assert(page.has_content?('test comment 2'))
        assert(page.has_content?('1 Comment'))
      end

      def test_featured_blog_entries_display_first
        blog = create_blog(
          entries: [
            {
              name: 'entry',
              author: 'jberesford',
              slug: 'entry-slug',
              featured: false
            },
            {
              name: 'featured entry',
              author: 'jberesford',
              slug: 'featured-entry-slug',
              featured: true
            }
          ]
        )

        visit storefront.blog_path(blog)

        assert_match(/featured entry.*entry/m, page.html)
      end

      def test_showing_a_featured_blog_entry_content_block
        content_page = create_page(name: 'Integration Page')
        entry = blog.entries.first

        content = Content.for(content_page)
        content.blocks.build(
          type: :blog_entry,
          data: {
            use_manual_entries: 'true',
            blog_entry: [entry.id]
          }
        )
        content.save!

        visit storefront.page_path(content_page)

        assert(page.has_content?('Entry 1'))
        assert(page.has_content?('A short summary about the entry'))
      end
    end
  end
end
