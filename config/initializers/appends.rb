Workarea.append_javascripts(
  'storefront.modules',
  'workarea/storefront/blog/modules/blog_comment_placeholder'
)

Workarea.append_stylesheets(
  'storefront.components',
  'workarea/storefront/blog/components/blog_entry',
  'workarea/storefront/blog/components/blog_entry_summary',
  'workarea/storefront/blog/components/featured_entry_content_block'
)

Workarea.append_partials(
  'admin.primary_nav',
  'workarea/admin/blog/menu'
)

Workarea.append_partials(
  'admin.dashboard.index.navigation',
  'workarea/admin/blog/dashboard_navigation'
)

Workarea.append_partials(
  'admin.releasable_models',
  'workarea/admin/content_blog_entries/releasable_model'
)
