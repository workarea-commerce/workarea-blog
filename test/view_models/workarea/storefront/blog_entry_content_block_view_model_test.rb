require 'test_helper'

module Workarea
  module Storefront
    class BlogEntryContentBlockViewModelTest < TestCase
      setup :blog
      setup :create_blog_entries

      def blog
        @blog ||= create_blog(name: 'Test')
      end

      def create_blog_entries
        4.times { @blog.entries.create!(name: 'Test', author: 'BC') }
      end

      def test_returns_a_blog_and_entry_object
        content = create_content
        block = content.blocks.create!(
          area: 'body',
          type_id: 'blog_entry',
          data: {
            use_manual_entries: 'true',
            blog_entry: [@blog.entries.first.id]
          }
        )

        view_model = ContentBlocks::BlogEntryContentBlockViewModel.new(block)

        assert_instance_of(Workarea::Storefront::BlogEntryViewModel, view_model.locals[:entries].first)
        assert_instance_of(Workarea::Storefront::BlogViewModel, view_model.locals[:entries].first.blog)
      end

      def test_returns_most_recent_blog_entry_by_default
        content = create_content
        block = content.blocks.create!(
          area: 'body',
          type_id: 'blog_entry',
          data: {
            number_of_entries: '1',
            use_manual_entries: 'false'
          }
        )
        view_model = ContentBlocks::BlogEntryContentBlockViewModel.new(block)

        assert_equal(@blog.entries.last.id, view_model.locals[:entries].first.id)
      end

      def test_can_return_multiple_recent_blog_entries
        content = create_content
        block = content.blocks.create!(
          area: 'body',
          type_id: 'blog_entry',
          data: {
            number_of_entries: '3',
            use_manual_entries: 'false'
          }
        )
        view_model = ContentBlocks::BlogEntryContentBlockViewModel.new(block)

        assert_equal(3, view_model.locals[:entries].count)
      end

      def test_can_return_recent_blog_entries_for_a_specific_blog
        new_blog = create_blog(name: 'New Blog')
        new_blog.entries.create!(name: 'New Post', author: 'BC')

        content = create_content
        block = content.blocks.create!(
          area: 'body',
          type_id: 'blog_entry',
          data: {
            blog: new_blog.id,
            number_of_entries: '1',
            use_manual_entries: 'false'
          }
        )
        view_model = ContentBlocks::BlogEntryContentBlockViewModel.new(block)

        assert_equal(1, view_model.locals[:entries].count)
        assert_equal(new_blog.id, view_model.locals[:entries].first.blog.id)
      end

      def test_can_return_multiple_manually_selected_entries
        content = create_content
        block = content.blocks.create!(
          area: 'body',
          type_id: 'blog_entry',
          data: {
            use_manual_entries: 'true',
            blog_entry: [@blog.entries.first.id, @blog.entries.second.id]
          }
        )

        view_model = ContentBlocks::BlogEntryContentBlockViewModel.new(block)
        assert_equal(2, view_model.locals[:entries].count)
      end
    end
  end
end
