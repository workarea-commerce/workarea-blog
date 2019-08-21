module Workarea
  module Storefront
    class BlogViewModel < ApplicationViewModel
      include DisplayContent
      include Pagination

      cattr_accessor :per_page
      self.per_page = 10

      def breadcrumbs
        @breadcrumbs ||= Navigation::Breadcrumbs.new(model)
      end

      def entries
        @entries ||=
          begin
            arr = scoped_entries
                  .page(page)
                  .per(self.class.per_page)
                  .map { |e| BlogEntryViewModel.new(e) }

            PagedArray.from(arr, page, self.class.per_page, total)
          end
      end

      def entries_on_index
        @entries ||=
          begin
            scoped_entries[0...Workarea.config.blog_entries_on_index]
            .map { |entry| Storefront::BlogEntryViewModel.wrap(entry) }
          end
      end

      def tags
        @tags ||= if model.entries.any?
                    model.entries.where(active: true).all_tags
                  else
                    []
                  end
      end

      def total
        @total ||= scoped_entries.count
      end

      def page
        options[:page].present? ? options[:page].to_f : 1
      end

      def updated_at
        @updated_at ||= model.entries.active.newest.first.try(:updated_at)
      end

      private

      def current_release
        Release.current || Release.new
      end

      def scoped_entries
        return scoped_entries_from_database if current_release.published?

        Kaminari.paginate_array(scoped_entries_filtered_by_current_release)
      end

      def ordered_entries
        model.entries.order_by([:featured.desc, :written_at.desc])
      end

      def scoped_entries_from_database
        scope = ordered_entries.active
        scope = scope.tagged_with(options[:tag]) if options[:tag].present?
        scope
      end

      def scoped_entries_filtered_by_current_release
        scope = ordered_entries.select(&:active?)
        scope.select! { |entry| entry.tags.include?(options[:tag]) } if options[:tag].present?
        scope
      end
    end
  end
end
