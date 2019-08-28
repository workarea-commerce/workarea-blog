Workarea.configure do |config|
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
