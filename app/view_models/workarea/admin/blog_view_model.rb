module Workarea
  module Admin
    class BlogViewModel < ApplicationViewModel
      include CommentableViewModel
      include ContentableViewModel
      # include RecommendableViewModel

      def timeline
        @timeline ||= TimelineViewModel.new(model)
      end
    end
  end
end
