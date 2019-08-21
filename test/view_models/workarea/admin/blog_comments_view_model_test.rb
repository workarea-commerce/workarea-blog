require 'test_helper'

module Workarea
  module Admin
    class BlogCommentsViewModelTest < TestCase
      setup :blog

      def blog
        @blog ||= create_blog(name: 'Test Blog',
                              entries: [
                                {
                                  name: 'Entry 1',
                                  author: 'BC',
                                  slug: 'entry1',
                                  summary: 'A short summary about the entry'
                                },
                                {
                                  name: 'Entry 2',
                                  author: 'BC',
                                  slug: 'entry2',
                                  summary: 'A different summary for this entry'
                                }
                              ])
      end

      def test_comments_filters_by_entry_if_passed
        view_model = Workarea::Admin::BlogCommentsViewModel.new(
          nil,
          content_blog_entry_id: @blog.entries.second.slug
        )

        assert_equal(0, view_model.comments.length)
      end

      def test_comments_returns_all_comments_if_not_filter_by_entry
        blog_comment = @blog.entries.first.comments.create!(
          user_id:   'userid',
          user_info: 'UC',
          body:      'Great writer! A+++++++. Will read again.'
        )

        view_model = Workarea::Admin::BlogCommentsViewModel.new(nil)

        assert_equal(1, view_model.comments.length)
        assert_equal(blog_comment, view_model.comments.first)
      end

      def test_entry_returns_the_entry_when_we_are_filtering_by_entry
        view_model = Workarea::Admin::BlogCommentsViewModel.new(
          nil,
          content_blog_entry_id: @blog.entries.first.slug
        )

        assert_equal(@blog.entries.first, view_model.blog_entry)
      end

      def test_entry_does_not_return_the_entry_if_we_are_not_filtering_by_entry
        view_model = Workarea::Admin::BlogCommentsViewModel.new(nil)
        assert_nil(view_model.blog_entry)
      end

      def test_blog_returns_the_blog_when_we_are_filtering_by_entry
        view_model = Workarea::Admin::BlogCommentsViewModel.new(
          nil,
          content_blog_entry_id: @blog.entries.first.slug
        )

        assert_equal(@blog, view_model.blog)
      end

      def test_blog_does_not_return_the_blog_if_we_are_not_filtering_by_entry
        view_model = Workarea::Admin::BlogCommentsViewModel.new(nil)
        assert_nil(view_model.blog)
      end
    end
  end
end
