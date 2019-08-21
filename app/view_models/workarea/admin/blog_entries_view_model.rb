module Workarea
  module Admin
    class BlogEntriesViewModel < ApplicationViewModel
      cattr_accessor :per_page
      self.per_page = 15

      delegate :sorts, to: Content::BlogEntry

      def entries
        @entries ||=
          begin
            blog_entries = blog.entries
                               .page(options[:page])
                               .per(per_page)
                               .order_by(options[:built_sort])

            PagedArray.from(
              Admin::BlogEntryViewModel.wrap(blog_entries),
              blog_entries.current_page,
              per_page,
              blog_entries.total_count
            )
          end
      end

      def blog
        @blog ||= Content::Blog.find_by(slug: options[:content_blog_id])
      end
    end
  end
end
