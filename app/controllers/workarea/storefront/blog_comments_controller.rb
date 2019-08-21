module Workarea
  module Storefront
    class BlogCommentsController < Storefront::ApplicationController
      def index
        @entry = Storefront::BlogEntryViewModel.new(
          Content::BlogEntry.find_by(slug: params[:blog_entry_id]),
          view_model_options
        )

        @comment = @entry.comments.build
      end
    end
  end
end
