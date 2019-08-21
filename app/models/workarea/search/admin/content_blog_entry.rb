module Workarea
  module Search
    class Admin
      class ContentBlogEntry < Search::Admin
        include Admin::Releasable

        def type
          'blog_entry'
        end

        def status
          if model.active?
            'active'
          else
            'inactive'
          end
        end

        def facets
          super.merge(blog_id: model.blog_id)
        end

        def jump_to_text
          model.name
        end

        def jump_to_position
          7
        end

        def search_text
          ['blog entry', model.name].flatten.join(' ')
        end
      end
    end
  end
end
