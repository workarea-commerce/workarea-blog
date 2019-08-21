require 'test_helper'

module Workarea
  module Blog
    class CreateBlogEntriesIntegrationTest < Workarea::IntegrationTest
      include Admin::IntegrationTest

      setup :blog

      def blog
        @blog ||= create_blog(
          name: 'Test Blog',
          entries: [
            { name: 'Entry 1', author: 'Ben Crouse' }
          ]
        )
      end

      def test_create
        post admin.create_content_blog_entries_path,
             params: {
               blog_entry: {
                 blog_id: blog.id,
                 name: 'Test blog entry',
                 author: 'Jake Beresford',
                 summary: 'Test blog entry summary',
                 tag_list: 'foo, bar, baz'
               }
             }

        assert_equal(2, Content::BlogEntry.count)
        entry = Content::BlogEntry.last

        assert('Test blog entry', entry.name)
        assert('Jake Beresford', entry.author)
        assert('Test blog entry summary', entry.summary)
        assert(%w[foo bar baz], entry.tags)
      end

      def test_thumbnail_image
        entry = Content::BlogEntry.first
        image = create_asset(
          name: 'Test Asset',
          file: product_image_file
        )

        post admin.save_thumbnail_image_create_content_blog_entry_path(entry),
             params: {
               id: entry.name,
               blog_entry: {
                 thumbnail_image: image.id
               }
             }

        assert(image.id, entry.thumbnail_image)
      end

      def test_publish
        entry = Content::BlogEntry.first
        create_release(name: 'Foo Release', publish_at: 1.week.from_now)
        get admin.publish_create_content_blog_entry_path(entry)

        assert(response.ok?)
        assert_includes(response.body, 'Foo Release')
      end

      def test_save_publish
        attrs = { name: 'New Entry', author: 'Jake Beresford', active: false }
        entry = create_blog_entry(attrs.merge(blog: blog))

        post admin.save_publish_create_content_blog_entry_path(entry),
             params: { activate: 'now' }

        assert(entry.reload.active?)

        entry.update_attributes(active: false)

        post admin.save_publish_create_content_blog_entry_path(entry),
             params: { activate: 'new_release', release: { name: '' } }

        assert(Release.empty?)
        assert(response.ok?)
        refute(response.redirect?)
        refute(entry.reload.active?)

        post admin.save_publish_create_content_blog_entry_path(entry),
             params: { activate: 'new_release', release: { name: 'Foo' } }

        refute(entry.reload.active?)
        assert_equal(1, Release.count)
        release = Release.first
        assert_equal('Foo', release.name)
        release.as_current { assert(entry.reload.active?) }

        release = create_release
        entry.update_attributes!(active: false)

        post admin.save_publish_create_content_blog_entry_path(entry),
             params: { activate: release.id }

        refute(entry.reload.active?)
        release.as_current { assert(entry.reload.active?) }
      end
    end
  end
end
