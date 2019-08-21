module Workarea
  module Search
    module Queries
      class BlogEntryAdmin
        include Query

        def initialize(params = {})
          super(params.merge(type: 'blog_entry', term_filters: %w[blog_id]))
        end
      end
    end
  end
end
