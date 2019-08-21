module Workarea
  class BlogEntrySeeds
    def perform
      puts 'Adding blog entries...'

      Sidekiq::Callbacks.disable do
        Content::Blog.all.each_with_index do |blog, blog_index|
          10.times do |entry_index|
            entry = Content::BlogEntry.create!(
              name: entry_titles[blog_index][entry_index],
              summary: Faker::Hipster.paragraph,
              author: Faker::Book.author,
              # thumbnail_image: blog_thumbnail(entry_index),
              tags: Faker::Hipster.words(3),
              blog_id: blog.id
            )

            content = Content.for(entry)

            content.blocks.create!(
              area: 'blog_content',
              type: 'text',
              data: {
                text: Faker::Hipster.paragraph(4)
              }
            )

            entry.save!
          end
        end
      end
    end

    def blog_thumbnail(entry_index)
      thumbnail_dir = "#{Workarea::Blog::Engine.root}/data/blog_thumbnails"
      thumbnail_count = Dir["#{thumbnail_dir}/*"].length
      thumbnail_num = rand(thumbnail_count + 1)

      File.new("#{thumbnail_dir}/thumbnail_#{thumbnail_num}.png") if thumbnail_num.nonzero?
    end

    private

    def entry_titles
      [
        [
          '3 Hot Fashion Tips For Fall',
          '1 Neat Trick To Keep Your Look Fresh',
          'How To Dress Up A Pair Of Boots',
          'How To Tell If Your Shirt Is On Backwards',
          'No-Nonsense Nautical Style',
          'Rules For Wearing White After Labor Day',
          'Insane Fashion Tips For Millenials',
          'Signs You Might Need A New Pair Of Pants',
          'Ultimate Guide To Hats',
          'Hack Your Wardrobe'
        ],
        [
          'The Secret of Fashion',
          '0 Tips That Will Make You Influential In Fashion',
          'How To Lose Money With Fashion',
          'The A - Z Guide Of Fashion',
          'Old School Fashion',
          'Fashion Strategies For Beginners',
          '9 Ridiculous Rules About couture',
          'The Modern Rules Of Couture',
          'Five Items You Should Have In Your Wardrobe',
          'The 7 Secrets That You Shouldn\'t Know About Dresses'
        ]
      ]
    end
  end
end
