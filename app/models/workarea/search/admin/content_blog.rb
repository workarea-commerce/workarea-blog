module Workarea
  module Search
    class Admin
      class ContentBlog < Search::Admin
        def type
          'blog'
        end

        def status
          'active'
        end

        def jump_to_text
          model.name
        end

        def jump_to_position
          6
        end

        def search_text
          ['blog', model.name, model.entries.map(&:name)].flatten.join(' ')
        end
      end
    end
  end
end
