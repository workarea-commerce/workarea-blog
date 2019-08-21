require 'test_helper'

module Workarea
  module Storefront
    class BlogContentBlockSystemTest < Workarea::SystemTest
      include BreakpointHelpers
      setup :set_content_page

      def set_content_page
        @content_page = create_page(name: 'Integration Page')
      end

      def test_blog_entry_content_block
        blog = create_blog(name: 'Test')

        blog.entries.create!(name: 'Test', author: 'BC', summary: 'Summary text')

        content = Content.for(@content_page)
        content.blocks.build(
          type: :blog_entry,
          data: {
            number_of_entries: '1',
            use_manual_entries: 'true',
            blog_entry: [blog.entries.first.id]
          }
        )
        content.save!

        visit storefront.page_path(@content_page)
        assert(page.has_content?(blog.entries.first.name))
        assert(page.has_content?(blog.entries.first.author))
        assert(page.has_content?(blog.entries.first.summary))
      end
    end
  end
end
