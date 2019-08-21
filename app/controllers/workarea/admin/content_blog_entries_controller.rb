module Workarea
  module Admin
    class ContentBlogEntriesController < Admin::ApplicationController
      required_permissions :marketing
      before_action :find_blog_entry, except: :index

      def index
        query_params = if params[:content_blog_id].blank?
          params
        else
          blog = Content::Blog.find_by(slug: params[:content_blog_id])
          params.merge(blog_id: blog.id.to_s)
        end

        search = Search::AdminBlogEntries.new(query_params)
        @search = SearchViewModel.new(search, view_model_options)
        @blog = BlogViewModel.new(blog, view_model_options)
      end

      def show
        @blog_entry = BlogEntryViewModel.new(@blog_entry, params)
      end

      def edit
        @blog_entry = BlogEntryViewModel.new(@blog_entry, params)
      end

      def update
        if @blog_entry.update_attributes(params[:blog_entry])
          flash[:success] = t('workarea.admin.content_blog_entries.flash_messages.updated')
          redirect_to edit_content_blog_entry_path(@blog_entry)
        else
          @blog_entry = BlogEntryViewModel.new(@blog_entry, params)
          render :edit
        end
      end

      def thumbnail_image
        @blog_entry = BlogEntryViewModel.wrap(@blog_entry, params)
      end

      def update_thumbnail_image
        if @blog_entry.update_attributes(params[:blog_entry])
          flash[:success] = t('workarea.admin.content_blog_entries.flash_messages.updated')
          redirect_to thumbnail_image_content_blog_entry_path(@blog_entry)
        else
          @blog_entry = BlogEntryViewModel.wrap(@blog_entry, params)
          render :thumbnail_image
        end
      end

      def destroy
        @blog_entry.destroy
        flash[:success] = t('workarea.admin.content_blog_entries.flash_messages.deleted')
        redirect_to content_blog_blog_entries_path(content_blog_id: @blog_entry.blog)
      end

      private

      def find_blog_entry
        if params[:id].present?
          @blog_entry = Content::BlogEntry.find_by(slug: params[:id])
        else
          model = Content::Blog.find_by(slug: params[:content_blog_id])
          @blog_entry = model.entries.build(params[:blog_entry])
        end
      end
    end
  end
end
