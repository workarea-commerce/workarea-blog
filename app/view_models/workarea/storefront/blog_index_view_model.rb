module Workarea
  module Storefront
    class BlogIndexViewModel < ApplicationViewModel
      include DisplayContent

      def breadcrumbs
        @breadcrumbs ||= Navigation::Breadcrumbs.new(model)
      end

      private

      def content_lookup
        'blog_landing_page'
      end
    end
  end
end
