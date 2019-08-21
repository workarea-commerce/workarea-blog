Workarea.configure do |config|
  # Number of articles to be displayed per blog on blog index page
  config.blog_entries_on_index ||= 4

  config.content_areas.merge!(
    'blog_entry' => %w[blog_content blog_header],
    'blog' => %w[header_content],
    'blog_landing_page' => %w[header_content]
  )

  config.wordpress_import = {
    blog_name: 'Wordpress Import',
    author_name: 'Wordpress User'
  }
end
