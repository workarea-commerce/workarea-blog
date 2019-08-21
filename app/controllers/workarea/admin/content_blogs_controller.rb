module Workarea
  module Admin
    class ContentBlogsController < Admin::ApplicationController
      required_permissions :marketing
      before_action :find_blog, except: :index

      def index
        search = Search::AdminBlogs.new(
          params.merge(autocomplete: request.xhr?)
        )
        @search = BlogSearchViewModel.new(search, params)
      end

      def show; end

      def create
        if @blog.save
          flash[:success] = 'Blog has been created'
          redirect_to edit_content_blog_path(@blog)
        else
          render :new
        end
      end

      def update
        if @blog.update_attributes(blog_params)
          flash[:success] = 'Blog has been updated'
          redirect_to edit_content_blog_path(@blog)
        else
          render :edit
        end
      end

      def destroy
        @blog.destroy
        flash[:success] = 'This blog has been removed'
        redirect_to content_blogs_path
      end

      private

      def find_blog
        @blog = if params[:id].present?
          BlogViewModel.new(Workarea::Content::Blog.find_by(slug: params[:id]))
        else
          BlogViewModel.new(Workarea::Content::Blog.new(blog_params))
        end
      end

      def blog_params
        return {} unless params[:blog].present?
        params[:blog].permit(:name, :slug, :navigation)
      end
    end
  end
end
