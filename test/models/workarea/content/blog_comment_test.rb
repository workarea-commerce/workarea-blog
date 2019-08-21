require 'test_helper'

module Workarea
  class Content::BlogCommentTest < TestCase
    setup :blog

    def blog
      @blog ||= create_blog(name: 'Test Blog',
                            entries: [
                              { name: 'Entry 1', author: 'BC' }
                            ])
    end

    def test_self_sorts_includes_pending_sort_if_pending_comments_present
      entry = blog.entries.first
      entry.comments.create(
        user_id: 'user1',
        body: 'this is a test comment',
        pending: true
      )
      entry.comments.create(
        user_id: 'user2',
        body: 'this is another test comment',
        pending: false
      )

      assert_equal([Sort.pending, Sort.newest], Workarea::Content::BlogComment.sorts)
    end

    def test_self_sorts_excludes_pending_sort_if_pending_comments_absent
      assert_equal([Sort.newest], Workarea::Content::BlogComment.sorts)
    end

    def test_update_count_updates_the_posts_comment_count
      entry = blog.entries.first
      entry.comments.create!(
        user_id: 'user2',
        body: 'this is another test comment',
        pending: false,
        approved: true
      )

      assert_equal(1, entry.comment_count)
    end

    def test_update_count_does_not_change_the_post_updated_at_value
      entry = blog.entries.first
      entry.comments.create!(
        user_id: 'user2',
        body: 'this is another test comment',
        pending: false
      )

      assert_equal(entry.created_at, entry.updated_at)
    end
  end
end
