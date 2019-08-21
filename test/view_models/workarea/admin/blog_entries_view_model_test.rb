require 'test_helper'

module Workarea
  module Blog
    module Admin
      class BlogEntriesViewModelTest < TestCase
        setup :create_blog_1
        setup :create_blog_2

        def create_blog_1
          @blog ||= create_blog(name: 'Test',
                                slug: 'test',
                                entries: [{ name: 'Entry', author: 'BC' }])
        end

        def create_blog_2
          create_blog(name: 'Test2',
                      slug: 'test2',
                      entries: [{ name: 'Entry2', author: 'BC' }])
        end

        def test_entries_only_shows_entries_for_this_blog
          view_model = Workarea::Admin::BlogEntriesViewModel.new(nil, content_blog_id: @blog.slug)

          assert_equal(1, view_model.entries.length)
          assert_equal(Workarea::Storefront::BlogEntryViewModel.new(@blog.entries.first), view_model.entries.first)
        end

        def test_blog_should_return_the_blog
          view_model = Workarea::Admin::BlogEntriesViewModel.new(nil, content_blog_id: @blog.slug)
          assert_equal(@blog, view_model.blog)
        end
      end
    end
  end
end
