module Workarea
  module Admin
    class ContentBlogCommentsController < Admin::ApplicationController
      required_permissions :marketing
      before_action :find_blog_comment, except: :index

      def index
        options = params.merge(built_sort: find_sort(Content::BlogComment))
        @blog_comments = Admin::BlogCommentsViewModel.new(nil, options)
      end

      def edit; end

      def update
        if @blog_comment.update_attributes(blog_comment_params)
          flash[:success] = 'Blog entry comment has been updated'
          redirect_to content_blog_user_comments_path(
            content_blog_entry_id: params[:content_blog_entry_id]
          )
        else
          render :edit
        end
      end

      def destroy
        @blog_comment.destroy
        flash[:success] = t('workarea.admin.content_blogs_comments.flash_messages.destroyed')
        redirect_to content_blog_user_comments_path
      end

      private

      def find_blog_comment
        if params[:id].present?
          @blog_comment = Content::BlogComment.find(params[:id])

          @user = User.where(id: @blog_comment.user_id).first
        end
      end

      def new_admin_comment_params
        params[:comment].permit(:body).merge(
          user_id: current_user.id,
          user_info: current_user.public_info
        )
      end

      def blog_comment_params
        return {} if params[:blog_comment].blank?
        params[:blog_comment].permit(:body, :pending, :approved)
      end
    end
  end
end
