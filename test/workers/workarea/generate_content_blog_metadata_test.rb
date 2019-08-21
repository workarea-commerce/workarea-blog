require 'test_helper'

module Workarea
  class GenerateContentBlogMetadataTest < TestCase
    def test_generate_metadata_for_blog
      blog = create_blog(name: 'foo')
      content = Content.for(blog)

      content.update!(automate_metadata: true)
      content.blocks.create!(type: 'html', data: { html: '<p>Lorem ipsum dolor</p>' })

      GenerateContentMetadata.new.perform

      assert_equal('foo', content.reload.browser_title)
      assert_equal('Lorem ipsum dolor', content.reload.meta_description)
    end
  end
end
