require 'test_helper'

module Workarea
  module Admin
    class BlogUserCommentsSystemTest < Workarea::SystemTest
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

      def test_approving_comments
        blog_entry = blog.entries.first
        blog_entry.comments.create!(
          user_id: Workarea::User.first.id,
          user_info: 'UC',
          body: 'test test test',
          pending: true
        )

        visit admin.content_blog_user_comments_path

        assert(page.has_content?('Blog Entry'))
        assert(page.has_content?('Pending'))

        click_link('Edit')

        find('label[for=blog_comment_approved_true]').click
        click_button 'save_blog_comment'

        assert(page.has_content?('Success'))
        assert(page.has_no_content?('Pending'))

        visit admin.activity_path
        assert(page.has_content?('blog comment'))
      end

      def test_moderating_comments_from_index
        pending = t('workarea.admin.content_blogs_comments.summary.pending')
        blog_entry = blog.entries.first
        bad_comment = create_blog_comment(
          entry: blog_entry,
          user_id: Workarea::User.first.id,
          user_info: 'UC',
          body: 'oh noes i said the bad word',
          pending: true
        )
        good_comment = create_blog_comment(
          entry: blog_entry,
          user_id: Workarea::User.first.id,
          user_info: 'UC',
          body: 'test test test',
          pending: true
        )

        visit admin.content_blog_user_comments_path

        assert_text(good_comment.body)
        assert_text(bad_comment.body)
        assert_text(pending, count: 2)

        within '.comments__comment:first-child' do
          click_link t('workarea.admin.content_blogs_comments.index.approve')
        end

        assert_text(pending, count: 1)

        within '.comments__comment:first-child' do
          click_link t('workarea.admin.content_blogs_comments.index.deny')
        end

        refute_text(pending)

        assert(good_comment.reload.approved)
        refute(bad_comment.reload.approved)
      end

      def test_deleting_a_comment
        blog_entry = blog.entries.first
        blog_entry.comments.create!(
          user_id:  Workarea::User.first.id,
          user_info: 'UC',
          body: 'Test Comment',
          pending: true,
          updated_at: Time.now - 2.days
        )

        visit admin.content_blog_user_comments_path

        within '.comments__comment', match: :first do
          click_link t('workarea.admin.actions.delete')
        end

        assert(page.has_content?(t('workarea.admin.content_blogs_comments.flash_messages.destroyed')))
        assert(page.has_no_content?('Test Comment'))
      end

      def test_view_and_sort_comments_for_only_that_blog_entry
        blog.entries.first.comments.create!(
          user_id: Workarea::User.first.id,
          body: 'One Thought',
          approved: false,
          pending: true,
          updated_at: Time.now - 1.day
        )
        blog.entries.first.comments.create!(
          user_id: Workarea::User.first.id,
          body: 'Two Thoughts',
          approved: false,
          pending: true,
          created_at: Time.now - 2.days
        )
        blog.entries.last.comments.create!(
          user_id: Workarea::User.first.id,
          body: 'Comment For Another Entry',
          approved: false,
          pending: true,
          created_at: Time.now - 1.day
        )

        entry = blog.entries.order_by(:created_at.asc).first

        visit admin.content_blog_user_comments_path(content_blog_entry_id: entry.slug)

        assert(page.has_content?('One Thought'))
        assert(page.has_no_content?('First Comment'))

        select 'Newest', from: 'sort'

        assert(page.has_no_content?('Comment For Another Entry'))
        assert(page.has_ordered_text?('One Thought', 'Two Thoughts'))
      end

      def test_importing_and_exporting
        entry = blog.entries.first
        comments = Array.new(2) do |i|
          entry.comments.create!(
            user_id: Workarea::User.first.id,
            user_info: 'UC',
            body: 'test test test',
            pending: true
          )
        end

        file = create_tempfile(DataFile::Csv.new.serialize(comments), extension: 'csv')

        visit admin.content_blog_user_comments_path(content_blog_entry_id: entry.slug)
        click_link t('workarea.admin.shared.bulk_actions.import')
        attach_file 'import[file]', file.path
        click_button 'create_import'

        assert_current_path(admin.content_blog_user_comments_path(content_blog_entry_id: entry.slug))
        assert(page.has_content?('Success'))

        click_link t('workarea.admin.shared.bulk_actions.export')

        Workarea.config.data_file_formats[1..-1].each do |format|
          click_link format.upcase
          assert(page.has_content?(format.upcase))
        end

        fill_in 'export[emails_list]', with: 'bcrouse@weblinc.com'
        click_button 'create_export'

        assert_current_path(admin.content_blog_user_comments_path(content_blog_entry_id: entry.slug))
        assert(page.has_content?('Success'))
      end
    end
  end
end
