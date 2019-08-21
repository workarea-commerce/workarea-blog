module Workarea
  module Search
    class AdminBlogEntries
      include Query
      include AdminIndexSearch
      include AdminSorting
      include Pagination

      document Search::Admin

      def initialize(params = {})
        super(params.merge(type: 'blog_entry'))
      end

      def facets
        super + [TermsFacet.new(self, 'blog_id')]
      end

      def displayed_facets
        facets.reject { |facet| facet.useless? || facet.name == 'blog_id' }
      end
    end
  end
end
