module Workarea
  module Admin
    class CreateContentBlogEntriesController < Admin::ApplicationController
      required_permissions :marketing
      before_action :find_blog_entry

      def new
        @blog = Admin::BlogViewModel.new(Workarea::Content::Blog.find_by(slug: params[:content_blog_id]))
        render :setup
      end

      def create
        @blog_entry.attributes = params[:blog_entry]

        if @blog_entry.save
          flash[:success] = t('workarea.admin.create_content_blog_entries.flash_messages.blog_entry_created')
          redirect_to thumbnail_image_create_content_blog_entry_path(@blog_entry)
        else
          render :setup, status: :unprocessable_entity
        end
      end

      def thumbnail_image
        render :thumbnail_image
      end

      def save_thumbnail_image
        @blog_entry.update_attributes(params[:blog_entry])
        redirect_to content_create_content_blog_entry_path(@blog_entry)
      end

      def content
        model = Content.for(@blog_entry.model)
        @content = Admin::ContentViewModel.new(model, view_model_options)
      end

      def featured_products
        search = Search::AdminProducts.new(view_model_options)
        @search = SearchViewModel.new(search, view_model_options)
      end

      def publish; end

      def save_publish
        publish = SavePublishing.new(@blog_entry, params)

        if publish.perform
          flash[:success] = t('workarea.admin.create_content_blog_entries.flash_messages.blog_entry_created')
          redirect_to content_blog_entry_path(@blog_entry)
        else
          flash[:error] = publish.errors.full_messages
          render :publish
        end
      end

      private

      def find_blog_entry
        model = if params[:id].present?
          Content::BlogEntry.find_by(slug: params[:id])
        else
          Content::BlogEntry.new(blog_id: params[:content_blog_id])
        end

        @blog_entry = Admin::BlogEntryViewModel.new(model, view_model_options)
      end
    end
  end
end
