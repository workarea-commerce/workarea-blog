require 'test_helper'

module Workarea
  module Admin
    class BlogSystemTest < Workarea::SystemTest
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

      def test_creating_a_blog
        visit admin.content_blogs_path
        click_link 'add_blog'

        fill_in 'blog_name', with: 'New Blog'
        click_button 'save_blog'
        assert(page.has_content?('Success'))

        visit admin.content_blogs_path
        assert(page.has_content?('New Blog'))
      end

      def test_managing_blogs
        visit admin.content_blog_path(blog)
        click_link t('workarea.admin.cards.attributes.title')

        fill_in 'blog_name', with: 'Edited Test Blog'
        click_button 'save_blog'
        assert(page.has_content?('Success'))

        visit admin.content_blogs_path
        assert(page.has_content?('Edited Test Blog'))
      end

      def test_deleting_blogs
        visit admin.content_blogs_path
        click_link 'Test Blog'

        visit admin.content_blog_path(blog)

        click_link t('workarea.admin.actions.delete')
        assert(page.has_content?('Success'))

        assert(page.has_no_content?('Edited Test Blog'))
      end

      def test_shows_the_admin_toolbar_for_blogs
        visit admin.toolbar_path(id: blog.to_global_id.to_param)
        click_link 'View Test Blog admin'
        assert(page.has_current_path?(admin.content_blog_path(blog)))

        visit admin.toolbar_path(id: blog.to_global_id.to_param)
        click_link t('workarea.admin.toolbar.edit_content')
        assert(page.has_current_path?(admin.edit_content_path(Content.for(blog))))
      end

      def test_importing_and_exporting
        blogs = Array.new(2) { |i| create_blog }
        file = create_tempfile(DataFile::Csv.new.serialize(blogs), extension: 'csv')

        visit admin.content_blogs_path
        click_link t('workarea.admin.shared.bulk_actions.import')
        attach_file 'import[file]', file.path
        click_button 'create_import'

        assert_current_path(admin.content_blogs_path)
        assert(page.has_content?('Success'))

        click_button t('workarea.admin.shared.bulk_actions.export')

        Workarea.config.data_file_formats[1..-1].each do |format|
          click_link format.upcase
          assert(page.has_content?(format.upcase))
        end

        fill_in 'export[emails_list]', with: 'bcrouse@weblinc.com'
        click_button 'create_export'

        assert_current_path(admin.content_blogs_path)
        assert(page.has_content?('Success'))
      end
    end
  end
end
