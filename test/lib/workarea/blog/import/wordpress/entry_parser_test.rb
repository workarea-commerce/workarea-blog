require 'test_helper'
require 'workarea/blog/import/wordpress/entry_parser'

module Workarea
  module Blog
    module Import
      module Wordpress
        class EntryParserTest < TestCase
          setup :entries

          def entries
            doc = Nokogiri::XML(wordpress_xml)

            @entries = Workarea::Blog::Import::Wordpress::EntryParser.new(doc).parse
          end

          def test_creates_array_of_entries
            assert(@entries.present?)
            assert_instance_of(Array, @entries)
            assert_equal(4, @entries.count)
          end

          def test_entry_hash_is_complete
            entry = @entries.first
            assert(entry.present?)
            assert_equal("p=3", entry[:guid_path])
            assert_equal("https://testingwordpressexports.wordpress.com/2018/11/15/the-journey-begins/", entry[:url])
            assert_equal("the-journey-begins", entry[:new_slug])
            assert_equal("testingwordpressexports.wordpress.com", entry[:wordpress_hostname])
            assert_equal(['Uncategorized'], entry[:tags])
            assert_equal("Thanks for joining me! <blockquote>Good company in a journey makes the way seem shorter. — Izaak Walton</blockquote><img class=\"wp-image-7 size-full\" src=\"https://twentysixteendemo.files.wordpress.com/2015/11/post.png\" alt=\"post\" width=\"1000\" height=\"563\" />", entry[:content])
          end

          def test_uses_configured_value_for_author
            entry = @entries.first
            assert_equal(Workarea.config.wordpress_import[:author_name], entry[:author])
          end
        end
      end
    end
  end
end
