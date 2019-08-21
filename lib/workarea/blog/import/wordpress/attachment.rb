module Workarea
  module Blog
    module Import
      module Wordpress
        class Attachment
          def initialize(url)
            @attachment_path = url
          end

          def save
            attributes = {
              name: file_name,
              tag_list: 'Wordpress',
              file: image_file
            }

            asset = Workarea::Content::Asset.create!(attributes)
            puts "Created Asset: #{asset.name}"
            asset
          end

          private

          def image_file
            Net::HTTP.get(uri)
          end

          def uri
            URI.parse(@attachment_path)
          end

          def file_name
            path = uri.path
            path.rpartition('.').first.split('/').join('-')
          end
        end
      end
    end
  end
end
