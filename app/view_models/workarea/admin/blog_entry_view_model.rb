module Workarea
  module Admin
    class BlogEntryViewModel < ApplicationViewModel
      include ContentableViewModel
      include FeaturedProductsViewModel

      def timeline
        @timeline ||= TimelineViewModel.new(model)
      end

      def thumbnail_image_url
        find_asset(model.thumbnail_image).url
      end

      def find_asset(id)
        id = id.to_s
        @assets ||= Hash.new do |hash, key|
          hash[key] = begin
                        Content::Asset.find(id)
                      rescue StandardError
                        Content::Asset.image_placeholder
                      end
        end

        @assets[id]
      end
    end
  end
end
