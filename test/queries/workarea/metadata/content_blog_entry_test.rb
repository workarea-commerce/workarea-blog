require 'test_helper'

module Workarea
  class Metadata
    class ContentBlogEntryTest < TestCase
      setup :set_page_and_metadata

      def set_page_and_metadata
        @entry = create_blog_entry(blog: create_blog)
        @content = Content.for(@entry)
        @metadata = ContentBlog.new(@content)
      end

      def test_defaults_to_blog_title
        assert_equal('Test Entry', @metadata.title)
      end

      def test_includes_parent_taxon_if_available
        category = create_category(name: 'Bar')
        taxon = create_taxon(name: 'Bar', navigable: category)
        create_taxon(name: 'Foo', parent: taxon, navigable: @entry)

        assert_equal('Test Entry - Bar', @metadata.title)
      end

      def test_defaults_to_text_extracted_from_content_blocks
        @content.blocks.create!(
          type: 'html',
          data: { html: '<p>Lorem ipsum dolor</p>' }
        )

        assert_equal('Lorem ipsum dolor', @metadata.description)
      end
    end
  end
end
