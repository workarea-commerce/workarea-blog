module Workarea
  class BlogSeeds
    def perform
      puts 'Adding blogs...'

      Sidekiq::Callbacks.disable do
        Content::Blog.create!(name: 'Hi, Fashion')
        Content::Blog.create!(name: 'HowTo Couture')
      end

      create_landing_page_content
      add_blog_navigation
    end

    def create_landing_page_content
      landing_page_content = Workarea::Content.for('Blog Landing Page')

      landing_page_content.blocks.create!(
        area: 'header_content',
        type: 'text',
        data: {
          text: Faker::Hipster.paragraph(4)
        }
      )

      landing_page_content.save!
    end

    def add_blog_navigation
      blog_root = add_blogs_index
      blogs = Workarea::Content::Blog.all

      blogs.each do |blog|
        blog_root.children.create!(navigable: blog)
      end

      add_taxonomy_content_block(blog_root)
    end

    def add_blogs_index
      Navigation::Taxon.root.children.create!(name: 'Blog', url: '/blogs')
    end

    def add_taxonomy_content_block(blog_root)
      menu = Navigation::Menu.create!(taxon: blog_root)
      content = Content.for(menu)
      content.blocks.create!(
        type: 'taxonomy',
        data: { start: blog_root.id.to_s }
      )
    end
  end
end
