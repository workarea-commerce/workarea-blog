require 'workarea/blog/import/wordpress/attachment'

namespace :workarea do
  namespace :blog do
    desc 'Import attachments from Wordpress'
    task :import_wordpress_attachments, [:path] => :environment do |t, args|
      args.with_defaults(path: "#{Rails.root}/data/blog/wordpress.xml")
      puts 'Importing all assets...'

      doc = Nokogiri::XML(File.open(args[:path]))
      attachment_urls = doc.xpath("//item[wp:post_type='attachment']/wp:attachment_url").children.map(&:text)

      attachment_urls.each do |url|
        Workarea::Blog::Import::Wordpress::Attachment.new(url).save
      end
    end
  end
end
