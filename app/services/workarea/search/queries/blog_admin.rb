module Workarea
  module Search
    module Queries
      class BlogAdmin
        include Query

        # repository Repositories::Admin
        # refinements(
        #   Refinements::AdminSearch,
        #   Refinements::AdminFilters,
        #   Refinements::AdminSorting
        # )

        def initialize(params = {})
          super(params.merge(type: 'blog'))
        end
      end
    end
  end
end
