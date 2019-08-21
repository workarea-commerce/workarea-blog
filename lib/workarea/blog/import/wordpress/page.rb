require 'workarea/blog/import/wordpress/content_cleaner'

module Workarea
  module Blog
    module Import
      module Wordpress
        class Page
          def initialize(page_hash)
            @page_hash = page_hash
          end

          def save
            if Workarea::Content::Page.where(slug: @page_hash[:new_slug]).present?
              puts "A Page already exists with the slug #{@page_hash[:new_slug]}"
              return
            end
            create_page
            create_redirects
            create_page_content
            puts "Imported #{@page.name}"
            @page
          end

          private

          def create_page
            @page ||= Workarea::Content::Page.create!(
              active: @page_hash[:published?],
              name: @page_hash[:page_title],
              slug: @page_hash[:new_slug]
            )
          end

          def create_page_content
            content = Content.for(@page)
            content.blocks.build(
              area: 'default',
              type_id: :html,
              data: {
                html: cleaned_content
              }
            )
            content.save!
          end

          def cleaned_content
            Workarea::Blog::Import::Wordpress::ContentCleaner.new(@page_hash[:content], @page_hash[:wordpress_hosname]).clean
          end

          def create_redirects
            old_path = URI.parse(@page_hash[:url]).path
            new_path = "/pages/#{@page_hash[:new_slug]}"

            new_redirect(old_path, new_path)
            new_redirect("/?#{@page_hash[:guid_path]}", new_path)
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
