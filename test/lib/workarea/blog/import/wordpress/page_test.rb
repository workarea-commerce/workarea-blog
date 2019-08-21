require 'test_helper'
require 'workarea/blog/import/wordpress/page'

module Workarea
  module Blog
    module Import
      module Wordpress
        class PageTest < TestCase
          setup :page_via_import

          def page_via_import
            @page_hash = {
              guid_path: 'https://www.example.com/?page=1',
              page_title: 'Test Page Title',
              url: 'https://www.example.com/path/to/test-page',
              new_slug: 'test-page',
              published?: true,
              content: "<h1>This is a heading</h1>"
            }

            @page = Workarea::Blog::Import::Wordpress::Page.new(@page_hash).save
          end

          def test_creates_the_page
            assert(@page.present?)
            assert_equal(@page_hash[:page_title], @page.name)
          end

          def test_html_block_for_page_is_created
            model = Workarea::Content.for(@page)

            assert_equal(1, model.blocks.size)
            assert_equal(:html, model.blocks.first.type_id)
          end

          def test_creates_a_redirect_for_the_entry
            redirect = Workarea::Navigation::Redirect.find_by(path: '/path/to/test-page')

            assert(redirect.present?)
            assert_equal("/pages/#{@page_hash[:new_slug]}", redirect[:destination])
          end

          def test_does_not_create_a_page_if_one_exists
            Workarea::Blog::Import::Wordpress::Page.new(@page_hash).save

            assert_equal(1, Workarea::Content::Page.count)
          end
        end
      end
    end
  end
end
