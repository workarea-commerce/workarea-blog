require 'test_helper'
require 'workarea/blog/import/wordpress/page_parser'

module Workarea
  module Blog
    module Import
      module Wordpress
        class PageParserTest < TestCase
          setup :pages

          def pages
            doc = Nokogiri::XML(wordpress_xml)

            @pages = Workarea::Blog::Import::Wordpress::PageParser.new(doc).parse
          end

          def test_creates_array_of_pages
            assert(@pages.present?)
            assert_instance_of(Array, @pages)
            assert_equal(2, @pages.count)
          end

          def test_page_hash_is_complete
            page = @pages.first
            assert(page.present?)
            assert_equal("page_id=2", page[:guid_path])
            assert_equal("https://testingwordpressexports.wordpress.com/contact/", page[:url])
            assert_equal("contact", page[:new_slug])
            assert_equal('[contact-form][contact-field label="Name" type="name" required="1"/][contact-field label="Email" type="email" required="1"/][contact-field label="Comment" type="textarea" required="1"/][/contact-form]', page[:content])
          end
        end
      end
    end
  end
end
