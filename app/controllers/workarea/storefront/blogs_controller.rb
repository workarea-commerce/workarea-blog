module Workarea
  module Storefront
    class BlogsController < Storefront::ApplicationController
      before_action :cache_page

      def index
        blogs = Workarea::Content::Blog.all.map do |blog|
          Storefront::BlogViewModel.new(blog, view_model_options)
        end
        @blog_index = Storefront::BlogIndexViewModel.new(blogs, view_model_options)
      end

      def show
        model = Content::Blog.find_by(slug: params[:id])
        @blog = Storefront::BlogViewModel.new(model, view_model_options)
      end
    end
  end
end
