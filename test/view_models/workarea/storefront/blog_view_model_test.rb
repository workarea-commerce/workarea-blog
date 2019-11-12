require 'test_helper'

module Workarea
  module Blog
    module Storefront
      class BlogViewModelTest < TestCase
        setup :blog
        setup :set_blog_entries_on_index
        teardown :reset_blog_entries_on_index

        def blog
          @blog ||= create_blog(name: 'Test', slug: 'test')
        end

        def set_blog_entries_on_index
          @blog_entries_on_index = Workarea.config.blog_entries_on_index
          Workarea.config.blog_entries_on_index = 4
        end

        def reset_blog_entries_on_index
          Workarea.config.blog_entries_on_index = @blog_entries_on_index
        end

        def test_entries_paginates
          view_model = Workarea::Storefront::BlogViewModel.new(@blog)

          tmp = Workarea::Storefront::BlogViewModel.per_page
          Workarea::Storefront::BlogViewModel.per_page = 1

          3.times { @blog.entries.create!(name: 'Test', author: 'BC') }

          assert_equal(1, view_model.entries.size)
          assert_equal(1, view_model.entries.current_page)
          assert_instance_of(Workarea::Storefront::BlogEntryViewModel, view_model.entries.first)

          Workarea::Storefront::BlogViewModel.per_page = tmp
        end

        def test_entries_filters_on_tag
          view_model = Workarea::Storefront::BlogViewModel.new(@blog)

          @blog.entries.create!(name: 'Test', author: 'BC', tag_list: 'foo')
          @blog.entries.create!(name: 'Test', author: 'BC', tag_list: 'bar')

          view_model.options[:tag] = 'foo'
          assert_equal(1, view_model.entries.size)
        end

        def test_entries_only_returns_active_entries
          view_model = Workarea::Storefront::BlogViewModel.new(@blog)

          @blog.entries.create!(name: 'Active Entry', author: 'BC', tag_list: 'baz', active: true)
          @blog.entries.create!(name: 'Inactive Entry', author: 'BC', tag_list: 'baz', active: false)

          assert_equal(['Active Entry'], view_model.entries.map(&:name))
        end

        def test_entries_sort_by_written_date
          view_model = Workarea::Storefront::BlogViewModel.new(@blog)

          @blog.entries.create!(name: '3', author: 'BC', tag_list: 'baz', written_at: Time.now - 3.days)
          @blog.entries.create!(name: '4', author: 'BC', tag_list: 'qux', written_at: Time.now - 4.days)
          @blog.entries.create!(name: '1', author: 'BC', tag_list: 'foo', written_at: Time.now - 1.day)
          @blog.entries.create!(name: '2', author: 'BC', tag_list: 'bar', written_at: Time.now - 2.days)

          assert_equal(%w[1 2 3 4], view_model.entries.map(&:name))
        end

        def test_entries_on_index_returns_the_first_4_entries_in_a_blog
          view_model = Workarea::Storefront::BlogViewModel.new(@blog)
          @blog.entries.create!(name: '1', author: 'BC', tag_list: 'foo', written_at: Time.now - 1.day)
          @blog.entries.create!(name: '2', author: 'BC', tag_list: 'bar', written_at: Time.now - 2.days)
          @blog.entries.create!(name: '3', author: 'BC', tag_list: 'baz', written_at: Time.now - 3.days)
          @blog.entries.create!(name: '4', author: 'BC', tag_list: 'qux', written_at: Time.now - 4.days)
          @blog.entries.create!(name: '5', author: 'BC', tag_list: 'qux', written_at: Time.now - 5.days)
          @blog.entries.create!(name: '6', author: 'BC', tag_list: 'qux', written_at: Time.now - 6.days, featured: true)

          assert_equal(4, view_model.entries_on_index.count)
          assert_equal(%w[6 1 2 3], view_model.entries_on_index.map(&:name))
          assert_instance_of(Workarea::Storefront::BlogEntryViewModel, view_model.entries_on_index.first)
        end

        def test_tags_includes_all_tags_for_active_entries_in_a_blog_as_facets
          view_model = Workarea::Storefront::BlogViewModel.new(@blog)
          @blog.entries.create!(
            name: 'Test', author: 'BC', tag_list: 'foo', active: true
          )
          @blog.entries.create!(
            name: 'Test', author: 'BC', tag_list: 'bar', active: true
          )
          @blog.entries.create!(
            name: 'Test', author: 'BC', tag_list: 'baz', active: false
          )

          view_model.options[:tag] = 'foo'
          assert_equal(2, view_model.tags.count)
        end

        def test_tags_empty_without_blog_entries_collection
          Workarea::Content::BlogEntry.collection.drop

          model = Workarea::Content::Blog.first
          view_model = Workarea::Storefront::BlogViewModel.new(model)

          assert_empty(view_model.tags)
        ensure
          Workarea::Content::BlogEntry.create_indexes
        end

        def test_updated_at_is_the_updated_at_date_of_the_newest_active_entry
          view_model = Workarea::Storefront::BlogViewModel.new(@blog)
          3.times do
            @blog.entries.create!(name: 'Test', author: 'BC', active: true)
          end

          assert_equal(@blog.entries.first.updated_at.to_s, view_model.updated_at.to_s)
        end

        def test_filters_entries_by_current_release
          release = create_release(publish_at: 1.hour.from_now, published_at: nil)
          view_model = Workarea::Storefront::BlogViewModel.new(@blog)
          3.times do
            @blog.entries.create!(name: 'Test', author: 'BC', active: true)
          end
          2.times do
            @blog.entries.create!(name: 'Unpublished', author: 'BC', active: false)
          end
          release.as_current do
            entry = @blog.entries.where(name: 'Unpublished').first
            entry.active = true
            entry.save!
          end
          unpublished = view_model.entries.select { |entry| entry.name == 'Unpublished' }

          assert_equal(3, view_model.entries.count)
          assert(unpublished.empty?)
          assert(release.publish!)

          view_model = Workarea::Storefront::BlogViewModel.new(@blog.reload)
          newly_published = view_model.entries.select do |entry|
            entry.name == 'Unpublished'
          end

          assert_equal(4, view_model.entries.count)
          refute(newly_published.empty?)
        end

        def test_total
          release = create_release(publish_at: 1.hour.from_now, published_at: nil)
          26.times do
            @blog.entries.create!(name: 'Test', author: 'BC', active: true)
            @blog.entries.create!(name: 'Unpublished', author: 'BC', active: false)
          end
          release.as_current do
            @blog.entries.where(name: 'Unpublished').each do |entry|
              entry.update!(active: true)
            end
          end

          view_model = Workarea::Storefront::BlogViewModel.new(@blog)

          assert_equal(26, view_model.total)

          release.as_current do
            view_model = Workarea::Storefront::BlogViewModel.new(@blog.reload)

            assert_equal(52, view_model.total)
          end
        end
      end
    end
  end
end
