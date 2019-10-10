module Workarea
  module Blog
    module Import
      module Wordpress
        class ContentCleaner
          def initialize(content, wordpress_hostname)
            @content = content
            @wordpress_hostname = wordpress_hostname
          end

          def clean
            @content = update_asset_paths
            @content = make_internal_links_relative
            @content
          end

          private

          def update_asset_paths
            doc = Nokogiri::HTML.fragment(@content)
            doc.search("img").each do |image|
              src = ensure_schema(image.attributes['src'].value)
              uri = URI.parse(src)
              next unless internal_link?(uri)
              new_asset = find_asset(uri)
              image.set_attribute("src", new_asset.url)
              image
            end
            doc.to_html
          end

          def find_asset(uri)
            name = uri.path.rpartition('.').first.split('/').join('-')
            Content::Asset.find_by(name: name) rescue Content::Asset.image_placeholder
          end

          def make_internal_links_relative
            doc = Nokogiri::HTML.fragment(@content)
            doc.search("a").each do |link|
              href = ensure_schema(link.attributes['href'].value)
              uri = URI.parse(href)
              next unless internal_link?(uri)
              link.set_attribute("href", uri.path)
              link
            end
            doc.to_html
          end

          def internal_link?(uri)
            uri.hostname == @wordpress_hostname
          end

          def ensure_schema(url)
            if url[/\Ahttp:\/\//] || url[/\Ahttps:\/\//]
              url
            else
              "https://#{url}"
            end
          end
        end
      end
    end
  end
end
