module Workarea
  module Admin
    module BlogsHelper
      def navigable_types
        super + [
          [
            t('workarea.admin.navigation_taxons.types.blog'),
            'blog',
            { data: { new_navigation_taxon_endpoint: content_blogs_path } }
          ],
          [
            t('workarea.admin.navigation_taxons.types.blog_entry'),
            'blog_entry',
            { data: { new_navigation_taxon_endpoint: content_blog_entries_path } }
          ]
        ]
      end

      def taxon_icon(taxon, options = {})
        if taxon.resource_name.blog?
          inline_svg('workarea/admin/blog/icons/blog.svg', options)
        elsif taxon.resource_name.blog_entry?
          inline_svg('workarea/admin/blog/icons/blog_entry.svg', options)
        else
          super
        end
      end

      def options_for_blogs(blog_id)
        return nil unless blog_id.present?

        model = Content::Blog.find(blog_id)
        options_for_select({ model.name => model.id }, model.id)
      end

      def options_for_blog_entries(entry_ids)
        return nil unless entry_ids.present?

        entries = Content::BlogEntry.in(id: entry_ids)
        options_from_collection_for_select(entries, 'id', 'name', entry_ids)
      end

      def storefront_content_preview_path(content)
        without_blog = super
        if without_blog.present?
          without_blog
        elsif content.contentable.is_a?(Content::Blog)
          storefront.blog_path(content.contentable, draft_id: content.id)
        end
      end

      def linkable_types
        super << [
          'Blog',
          'blog',
          { data: { new_navigation_link_endpoint: content_blogs_path(format: 'json') } }
        ]
      end
    end
  end
end
