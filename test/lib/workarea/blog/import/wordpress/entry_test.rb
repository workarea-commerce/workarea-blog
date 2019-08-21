require 'test_helper'
require 'workarea/blog/import/wordpress/entry'

module Workarea
  module Blog
    module Import
      module Wordpress
        class EntryTest < TestCase
          setup :blog
          setup :entry_via_import

          def blog
            @blog = create_blog
          end

          def entry_via_import
            @post_hash = {
              guid_path: 'https://www.example.com/?p=1',
              title: 'Test Post Title',
              url: 'https://www.example.com/path/to/test-post',
              new_slug: 'test-post',
              published?: true,
              published_date: Time.now,
              tags: ['Wordpress Tag', 'Uncategorized'],
              author: Workarea.config.wordpress_import[:author_name],
              content: "<h1>This is a heading</h1>",
              wordpress_hostname: 'https://www.example.com'
            }

            @entry = Workarea::Blog::Import::Wordpress::Entry.new(@post_hash, @blog).save
          end

          def test_creates_the_entry
            assert(@entry.present?)
            assert_equal(@post_hash[:title], @entry.name)
          end

          def test_html_block_for_entry_is_created
            model = Workarea::Content.for(@entry)

            assert_equal(1, model.blocks.size)
            assert_equal(:html, model.blocks.first.type_id)
          end

          def test_creates_a_redirect_for_the_entry
            redirect = Workarea::Navigation::Redirect.find_by(path: '/path/to/test-post')

            assert(redirect.present?)
            assert_equal("/blog_entries/#{@post_hash[:new_slug]}", redirect[:destination])
          end

          def test_does_not_create_an_entry_if_one_exists
            Workarea::Blog::Import::Wordpress::Entry.new(@post_hash, @blog).save

            assert_equal(1, @blog.entries.size)
          end
        end
      end
    end
  end
end
