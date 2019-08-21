require 'workarea/blog/import/wordpress/content_cleaner'

module Workarea
  module Blog
    module Import
      module Wordpress
        class Entry
          def initialize(post_hash, blog)
            @post_hash = post_hash
            @blog = blog
          end

          def save
            if Workarea::Content::BlogEntry.where(slug: @post_hash[:new_slug]).present?
              puts "An entry already exists with the slug #{@post_hash[:new_slug]}"
              return
            end
            create_entry
            create_redirects
            create_entry_content
            puts "Imported #{@entry.name}"
            @entry
          end

          private

          def create_entry
            @entry ||= @blog.entries.create!(
              tags: @post_hash[:tags],
              active: @post_hash[:published?],
              name: @post_hash[:title],
              slug: @post_hash[:new_slug],
              author: @post_hash[:author],
              written_at: @post_hash[:published_date]
            )
          end

          def create_entry_content
            content = Content.for(@entry)
            content.blocks.build(
              area: 'blog_content',
              type_id: :html,
              data: {
                html: cleaned_content
              }
            )
            content.save!
          end

          def cleaned_content
            Workarea::Blog::Import::Wordpress::ContentCleaner.new(
              @post_hash[:content],
              @post_hash[:wordpress_hosname]
            ).clean
          end

          def create_redirects
            old_path = URI.parse(@post_hash[:url]).path
            new_path = "/blog_entries/#{@post_hash[:new_slug]}"

            new_redirect(old_path, new_path)
            new_redirect("/?#{@post_hash[:guid_path]}", new_path)
          end

          def new_redirect(old_path, new_path)
            return if Workarea::Navigation::Redirect.find_by_path(old_path).present?
            Workarea::Navigation::Redirect.create!(
              path: old_path,
              destination: new_path
            )
          end
        end
      end
    end
  end
end
