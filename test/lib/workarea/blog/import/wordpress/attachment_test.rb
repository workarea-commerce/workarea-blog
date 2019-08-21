require 'test_helper'
require 'workarea/blog/import/wordpress/attachment'

module Workarea
  module Blog
    module Import
      module Wordpress
        class AttachmentTest < TestCase
          def test_creates_a_new_asset_from_url
            url = 'https://testingwordpressexports.files.wordpress.com/2018/11/person-smartphone-office-table.jpeg'

            asset = Workarea::Blog::Import::Wordpress::Attachment.new(url).save
            assert_equal('-2018-11-person-smartphone-office-table', asset.name)
            assert_equal(['Wordpress'], asset.tags)
          end
        end
      end
    end
  end
end
