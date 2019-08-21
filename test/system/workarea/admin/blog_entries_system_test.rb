require 'test_helper'

module Workarea
  module Admin
    class BlogEntrySystemTest < Workarea::SystemTest
      include Admin::IntegrationTest

      setup :blog

      def blog
        @blog ||= create_blog(
          name: 'Test Blog',
          entries: [
            { name: 'Entry 1', author: 'Ben Crouse' },
            { name: 'Entry 2', author: 'Ben Crouse' }
          ]
        )
      end

      def test_creating_a_blog_entry
        visit admin.content_blog_blog_entries_path(content_blog_id: blog)

        click_link t('workarea.admin.content_blog_entries.index.new_blog_entry')

        fill_in 'blog_entry[name]',    with: 'Test Entry'
        fill_in 'blog_entry[author]',  with: 'Eric Pigeon'
        fill_in 'blog_entry[summary]', with: 'A test blog entry'

        click_button t('workarea.admin.create_content_blog_entries.setup.button')

        create_asset(name: 'Test Asset', file: product_image_file, tag_list: 'foo,bar,baz')
        click_link t('workarea.admin.content_blocks.asset.select_an_asset')
        within '#takeover' do
          click_link 'Test Asset'
        end

        click_button t('workarea.admin.create_content_blog_entries.thumbnail_image.button')
        click_link t('workarea.admin.create_content_blog_entries.content.button')
      end

      def test_editing_attributes
        entry = blog.entries.first

        visit admin.edit_content_blog_entry_path(entry)

        fill_in 'blog_entry[name]',    with: 'Test Entry'
        fill_in 'blog_entry[author]',  with: 'Eric Pigeon'
        fill_in 'blog_entry[summary]', with: 'A test blog entry'

        click_button 'save_blog_entry'

        assert(page.has_content?(t('workarea.admin.content_blog_entries.flash_messages.updated')))
        assert(page.has_current_path?(admin.edit_content_blog_entry_path(entry)))
      end

      def test_editing_thumbnail
        entry = blog.entries.first

        visit admin.thumbnail_image_content_blog_entry_path(entry)

        click_button 'save_blog_entry'

        assert(page.has_content?(t('workarea.admin.content_blog_entries.flash_messages.updated')))
        assert(page.has_current_path?(admin.thumbnail_image_content_blog_entry_path(entry)))
      end

      def test_deleting_a_blog_entry
        visit admin.content_blog_entry_path(blog.entries.first)
        click_link t('workarea.admin.actions.delete')

        assert page.has_text?(t('workarea.admin.content_blog_entries.flash_messages.deleted'))
      end

      def test_importing_and_exporting
        file = create_tempfile(
          DataFile::Csv.new.serialize(blog.entries),
          extension: 'csv'
        )

        visit admin.content_blog_blog_entries_path(content_blog_id: blog)
        click_link t('workarea.admin.shared.bulk_actions.import')
        attach_file 'import[file]', file.path
        click_button 'create_import'

        assert_current_path(admin.content_blog_blog_entries_path(content_blog_id: blog))
        assert(page.has_content?('Success'))

        click_button t('workarea.admin.shared.bulk_actions.export')

        Workarea.config.data_file_formats[1..-1].each do |format|
          click_link format.upcase
          assert(page.has_content?(format.upcase))
        end

        fill_in 'export[emails_list]', with: 'bcrouse@weblinc.com'
        click_button 'create_export'

        assert_current_path(admin.content_blog_blog_entries_path(content_blog_id: blog))
        assert(page.has_content?('Success'))
      end
    end
  end
end
