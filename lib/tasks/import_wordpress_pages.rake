require 'workarea/blog/import/wordpress/page'
require 'workarea/blog/import/wordpress/page_parser'

namespace :workarea do
  namespace :blog do
    desc 'Import posts from Wordpress'
    task :import_wordpress_pages, [:path] => :environment do |t, args|
      args.with_defaults(path: "#{Rails.root}/data/blog/wordpress.xml")
      puts 'Importing all Wordpress pages...'

      doc = Nokogiri::XML(File.open(args[:path]))

      all_pages = Workarea::Blog::Import::Wordpress::PageParser.new(doc).parse

      all_pages.each do |page|
        Workarea::Blog::Import::Wordpress::Page.new(page).save
      end
      puts 'Wordpress pages imported!'
    end
  end
end
