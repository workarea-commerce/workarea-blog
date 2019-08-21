require 'test_helper'

module Workarea
  module Storefront
    module Blog
      class BlogEntryViewModelTest < TestCase
        def test_comments_only_shows_approved_comments
          blog = create_blog(
            entries: [{
              name: 'Test Entry',
              comments: [
                { user_id: user.id },
                { user_id: user.id, approved: true }
              ]
            }]
          )

          view_model = Workarea::Storefront::BlogEntryViewModel.new(blog.entries.first)

          assert_equal(1, view_model.comments.length)
        end

        def test_products
          3.times.map { |id| create_product(id: id) }

          product_ids = [1, 2, 0].map(&:to_s)
          blog = create_blog(
            entries: [{
              name: 'Test Entry',
              product_ids: product_ids
            }]
          )
          entry = blog.entries.first
          view_model = Workarea::Storefront::BlogEntryViewModel.new(entry)

          assert_equal(product_ids, view_model.products.map(&:id))
        end

        private

        def user
          @user ||= create_user
        end
      end
    end
  end
end
