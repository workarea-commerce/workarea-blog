require 'test_helper'
require 'workarea/blog/import/wordpress/content_cleaner'

module Workarea
  module Blog
    module Import
      module Wordpress
        class ContentCleanerTest < TestCase
          setup :asset

          def asset
            @asset ||= create_asset(
              name: '-test-asset',
              file: product_image_file
            )
          end

          def test_updates_asset_paths
            @sample_post ||= {
              wordpress_hostname: 'www.example.com',
              content: "<h1>This is a heading</h1><img src='https://www.example.com#{@asset.url}'/>"
            }

            content = Workarea::Blog::Import::Wordpress::ContentCleaner.new(@sample_post[:content], @sample_post[:wordpress_hostname]).clean

            refute_includes(content, 'https://www.example.com')
          end

          def test_rewrites_internal_links_as_relative_path
            @sample_post ||= {
              wordpress_hostname: 'www.example.com',
              content: "<h1>This is a heading</h1><a href='https://www.example.com/test-post-2'>Test Link</a>"
            }

            content = Workarea::Blog::Import::Wordpress::ContentCleaner.new(@sample_post[:content], @sample_post[:wordpress_hostname]).clean

            assert_includes(content, 'href="/test-post-2"')
          end

          def test_rewrites_links_without_scheme
            @sample_post ||= {
              wordpress_hostname: 'www.example.com',
              content: "<h1>This is a heading</h1><a href='www.example.com/test-post-2'>Test Link</a>"
            }

            content = Workarea::Blog::Import::Wordpress::ContentCleaner.new(@sample_post[:content], @sample_post[:wordpress_hostname]).clean

            assert_includes(content, 'href="/test-post-2"')
          end

          def test_does_not_rewrite_external_links
            @sample_post ||= {
              wordpress_hostname: 'www.example.com',
              content: "<h1>This is a heading</h1><a href='https://www.external-site.com/test-post-2'>Test External Link</a>"
            }

            content = Workarea::Blog::Import::Wordpress::ContentCleaner.new(@sample_post[:content], @sample_post[:wordpress_hostname]).clean

            assert_includes(content, 'href="https://www.external-site.com/test-post-2"')
          end
        end
      end
    end
  end
end
