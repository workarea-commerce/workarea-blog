require 'test_helper'

module Workarea
  module Admin
    class BlogTaxonomySystemTest < Workarea::SystemTest
      include Admin::IntegrationTest

      def test_blog_and_blog_entry_can_be_added_as_taxon
        visit admin.navigation_taxons_path
        find('.menu-editor__add-item-button--last-position').click

        assert(page.has_content?('Add Taxonomy'))

        dropdown = page.find('#navigable_type')
        options = dropdown.all('option').map(&:text)
        assert_includes(options, 'Blog')
        assert_includes(options, 'Blog Entry')
      end
    end
  end
end
