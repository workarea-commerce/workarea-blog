module Workarea
  module Factories
    module Blog
      Factories.add(self)

      def create_blog(overrides = {})
        attributes = { name: 'Test Blog', entries: [] }.merge(overrides)

        Workarea::Content::Blog.new(attributes.except(:entries)).tap do |blog|
          blog.save!

          attributes[:entries].each { |entry| create_blog_entry(entry.merge(blog: blog)) }
        end
      end

      def create_blog_entry(overrides = {})
        attrs = { name: 'Test Entry', author: 'Eric Pigeon', comments: [] }.merge(overrides)

        Workarea::Content::BlogEntry.new(attrs.except(:comments)).tap do |blog_entry|
          blog_entry.save!

          attrs[:comments].each { |comment| create_blog_comment(comment.merge(entry: blog_entry)) }
        end
      end

      def create_blog_comment(overrides = {})
        attrs = { body: 'test comment' }.merge(overrides)

        Workarea::Content::BlogComment.create!(attrs)
      end
    end
  end
end
