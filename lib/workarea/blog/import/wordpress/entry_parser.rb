module Workarea
  module Blog
    module Import
      module Wordpress
        class EntryParser
          def initialize(doc)
            @posts = doc.xpath('//item[wp:post_type="post"]')
          end

          def parse
            @posts.map do |post|
              {
                guid_path: guid_path(post),
                title: post_title(post),
                url: post_url(post),
                new_slug: File.basename(post_url(post)),
                published?: published?(post),
                published_date: published_date(post),
                tags: tags(post),
                author: Workarea.config.wordpress_import[:author_name],
                content: content(post),
                wordpress_hostname: wordpress_hostname(post)
              }
            end
          end

          private

          def guid_path(post)
            URI.parse(post.xpath('./guid').text).query
          end

          def post_title(post)
            post.xpath('./title').text
          end

          def post_url(post)
            post.xpath('./link').text
          end

          def published?(post)
            post.xpath('./wp:status').text == 'publish'
          end

          def published_date(post)
            post.xpath('./pubDate').text.to_datetime
          end

          def tags(post)
            post.xpath('./category').map(&:text)
          end

          def content(post)
            post.xpath('./content:encoded').inner_html
          end

          def wordpress_hostname(post)
            URI.parse(post.xpath('./link').text).hostname
          end
        end
      end
    end
  end
end
