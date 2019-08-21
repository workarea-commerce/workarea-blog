require 'workarea/blog/import/wordpress/content_cleaner'

module Workarea
  module Blog
    module Import
      module Wordpress
        class PageParser
          def initialize(doc)
            @pages = doc.xpath("//item[wp:post_type='page']")
          end

          def parse
            @pages.map do |page|
              {
                guid_path: guid_path(page),
                page_title: page_title(page),
                url: page_url(page),
                new_slug: File.basename(page_url(page)),
                content: content(page),
                published?: published?(page)
              }
            end
          end

          private

          def guid_path(page)
            URI.parse(page.xpath('./guid').text).query
          end

          def page_title(page)
            page.xpath('./title').text
          end

          def page_url(page)
            page.xpath('./link').text
          end

          def content(page)
            page.xpath('./content:encoded').inner_html
          end

          def published?(page)
            page.xpath('./wp:status').text == 'publish'
          end
        end
      end
    end
  end
end
