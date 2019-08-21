namespace :workarea do
  namespace :blog do
    desc 'Import Wordpress XML'
    task :import_wordpress, [:path] => :environment do |t, args|
      args.with_defaults(path: 'data/blog/wordpress.xml')
      puts 'Importing wordpress content...'
      Rake::Task['workarea:blog:import_wordpress_attachments'].invoke(args[:path])
      Rake::Task['workarea:blog:import_wordpress_posts'].invoke(args[:path])
      Rake::Task['workarea:blog:import_wordpress_pages'].invoke(args[:path])
      puts 'Wordpress import complete!'
    end
  end
end
