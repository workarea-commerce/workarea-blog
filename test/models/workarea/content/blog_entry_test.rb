require 'test_helper'

module Workarea
  class Content::BlogEntryTest < TestCase
    setup :blog

    def blog
      @blog ||= create_blog(name: 'Test Blog')
    end

    def test_newest_sort
      first  = blog.entries.create!(name: 'One', author: 'BC', updated_at: Time.now + 1.day)
      second = blog.entries.create!(name: 'Two', author: 'BC', updated_at: Time.now - 1.day)
      assert_equal([first, second], blog.entries.newest.to_a)
    end
  end
end
