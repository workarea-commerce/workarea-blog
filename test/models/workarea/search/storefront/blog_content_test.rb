require 'test_helper'

module Workarea
  if Plugin.installed?(:content_search)
    module Search
      class Storefront
        class BlogContentTest < Workarea::TestCase
          include TestCase::SearchIndexing

          setup :setup_models

          def setup_models
            @entry = create_blog_entry(blog: create_blog)
            @content = Workarea::Content.for(@entry)
            @content.blocks.create!(
              type: :html,
              data: { 'html' => '<p>lorem ipsum dolor sit amet</p</p>' }
            )
          end

          def test_use_summary_for_text_when_available
            @entry.update!(summary: 'foo bar baz')
            indexed = Content.new(@content.reload)

            assert_equal('foo bar baz', indexed.text)
          end

          def test_fall_back_to_default_block_text_extraction
            indexed = Content.new(@content.reload)

            assert_equal('lorem ipsum dolor sit amet', indexed.text)
          end
        end
      end
    end
  end
end
