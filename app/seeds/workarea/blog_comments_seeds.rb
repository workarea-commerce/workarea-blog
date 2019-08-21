module Workarea
  class BlogCommentSeeds
    def perform
      puts 'Adding blog comments...'

      Sidekiq::Callbacks.disable do
        Content::BlogEntry.all.each do |entry|
          3.times do |_i|
            user = Workarea::User.sample

            comment = Content::BlogComment.create!(
              user_id: user.id,
              user_info: user.public_info,
              body: Faker::Hipster.paragraph,
              entry: entry,
              pending: false,
              approved: true
            )

            comment.save!
          end
        end
      end
    end
  end
end
