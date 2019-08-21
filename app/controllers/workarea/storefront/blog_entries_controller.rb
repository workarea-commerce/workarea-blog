module Workarea
  module Storefront
    class BlogEntriesController < Storefront::ApplicationController
      before_action :cache_page, only: :show
      before_action :require_login, only: :add_comment

      def show
        model = Content::BlogEntry.find_by(slug: params[:id])
        raise InvalidDisplay unless model.active?

        @entry = Storefront::BlogEntryViewModel.new(model, view_model_options)
      end

      def add_comment
        model = Content::BlogEntry.find_by(slug: params[:blog_entry_id])
        @entry = Storefront::BlogEntryViewModel.new(model, view_model_options)

        if current_user.public_info.blank?
          if params[:first_name].blank? || params[:last_name].blank?
            flash[:error] = 'First and last name are required'
            render(:show) && return
          else
            current_user.update_attributes(params.permit(:first_name, :last_name))
          end
        end

        @comment = model.comments.build(comment_params)

        if @comment.save
          flash[:success] = 'Your comment has been submitted. Thanks!'
          redirect_to blog_entry_path(@entry)
        else
          flash[:error] = 'There was a problem saving your comment.'
          render :show
        end
      end

      private

      def comment_params
        params.permit(:body).merge(
          user_id: current_user.id,
          user_info: current_user.public_info
        )
      end
    end
  end
end
