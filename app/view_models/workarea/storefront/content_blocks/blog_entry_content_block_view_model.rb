module Workarea
  module Storefront
    module ContentBlocks
      class BlogEntryContentBlockViewModel < ContentBlockViewModel
        def locals
          return super if manual_entries_missing?

          super.merge(entries: entries)
        end

        def multiple_entries?
          if use_manual_entries?
            model.data[:blog_entry].count > 1
          else
            model.data[:number_of_entries] > 1
          end
        end

        private

        def entries
          @entries ||= if use_manual_entries?
            manual_entries
          else
            recent_entries
          end
        end

        def recent_entries
          entries = if model.data[:blog].present?
            blog = Workarea::Content::Blog.find(model.data[:blog])
            blog.entries.desc('written_at').limit(model.data[:number_of_entries])
          else
            Workarea::Content::BlogEntry.all.desc('written_at').limit(model.data[:number_of_entries])
          end

          Storefront::BlogEntryViewModel.wrap(entries)
        end

        def manual_entries
          entries = Workarea::Content::BlogEntry.find(model.data[:blog_entry].reject(&:empty?))
          Array.wrap(Storefront::BlogEntryViewModel.wrap(entries))
        end

        def use_manual_entries?
          model.data[:use_manual_entries]
        end

        def manual_entries_missing?
          use_manual_entries? && model.data[:blog_entry].empty?
        end

        def entry
          @entry ||=
            begin
              blog_entry = Workarea::Content::BlogEntry.find(model.data[:id])
              Storefront::BlogEntryViewModel.wrap(blog_entry)
            end
        end
      end
    end
  end
end
