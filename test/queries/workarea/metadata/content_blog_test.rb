require 'test_helper'

module Workarea
  class Metadata
    class ContentBlogTest < TestCase
      setup :set_page_and_metadata

      def set_page_and_metadata
        @blog = create_blog(name: 'Foo')
        @content = Content.for(@blog)
        @metadata = ContentBlog.new(@content)
      end

      def test_defaults_to_blog_title
        assert_equal('Foo', @metadata.title)
      end

      def test_includes_parent_taxon_if_available
        category = create_category(name: 'Bar')
        taxon = create_taxon(name: 'Bar', navigable: category)
        create_taxon(name: 'Foo', parent: taxon, navigable: @blog)

        assert_equal('Foo - Bar', @metadata.title)
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
