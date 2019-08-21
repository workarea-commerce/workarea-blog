require 'workarea/blog/import/wordpress/entry'
require 'workarea/blog/import/wordpress/entry_parser'

namespace :workarea do
  namespace :blog do
    desc 'Import posts from Wordpress'
    task :import_wordpress_posts, [:path] => :environment do |t, args|
      args.with_defaults(path: "#{Rails.root}/data/blog/wordpress.xml")
      puts 'Importing all Wordpress posts...'

      blog_name = Workarea.config.wordpress_import[:blog_name]
      blog =
        Workarea::Content::Blog.where(name: blog_name).first ||
        Workarea::Content::Blog.create(name: blog_name)

      doc = Nokogiri::XML(File.open(args[:path]))
      all_posts = Workarea::Blog::Import::Wordpress::EntryParser.new(doc).parse

      all_posts.each do |post|
        Workarea::Blog::Import::Wordpress::Entry.new(post, blog).save
      end
      puts 'Wordpress posts imported!'
    end
  end
end
