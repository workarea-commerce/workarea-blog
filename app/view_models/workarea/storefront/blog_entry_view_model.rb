module Workarea
  module Storefront
    class BlogEntryViewModel < ApplicationViewModel
      include DisplayContent

      def blog
        @blog ||= Storefront::BlogViewModel.new(model.blog)
      end

      def comments
        @comments ||= model.comments.approved.limit(100)
      end

      def products
        @products ||= Workarea::Storefront::ProductViewModel.wrap(
          Catalog::Product.find_ordered(product_ids)
        )
      end

      def thumbnail_image_url
        find_asset(model.thumbnail_image).url(host: thumbnail_image_url_host)
      end

      # This ensures memoization happens
      def find_asset(id)
        @assets ||= {}
        return @assets[id.to_s] if @assets[id.to_s].present?

        @assets[id.to_s] = begin
                             Content::Asset.find(id)
                           rescue StandardError
                             Content::Asset.placeholder
                           end
      end

      private

      def thumbnail_image_url_host
        Rails.configuration.action_controller.asset_host
      end
    end
  end
end
