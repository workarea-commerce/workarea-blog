module Workarea
  module Admin
    class BlogCommentsViewModel < ApplicationViewModel
      cattr_accessor :per_page
      self.per_page = 15

      delegate :sorts, to: Content::BlogComment

      def comments
        return @comments if defined?(@comments)

        comments = if options[:content_blog_entry_id].present?
          blog_entry
            .comments
            .page(options[:page])
            .per(per_page)
            .order_by(options[:built_sort])
        else
          Content::BlogComment
            .page(options[:page])
            .per(per_page)
            .order_by(options[:built_sort])
        end

        @comments = PagedArray.from(
          comments,
          comments.current_page,
          per_page,
          comments.total_count
        )
      end

      def blog_entry
        return nil unless options[:content_blog_entry_id].present?
        @blog_entry ||= Content::BlogEntry.find_by(slug:
          options[:content_blog_entry_id])
      end

      def blog
        return nil unless blog_entry.present?
        blog_entry.blog
      end
    end
  end
end
