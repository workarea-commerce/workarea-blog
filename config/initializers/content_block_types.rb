Workarea::Content.define_block_types do
  block_type 'Blog Entry' do
    description 'Feature a blog entry as a content block'
    view_model 'Workarea::Storefront::ContentBlocks::BlogEntryContentBlockViewModel'
    icon 'workarea/admin/blog/content_block_types/blog_entry.svg'

    field 'Blog', :blog_id, default: ''
    field 'Number of entries', :options, values: %w[1 2 3 4], default: '1'
    field 'Use manual entries', :boolean, default: false

    field 'Blog Entry', :blog_entry_id, default: ''
  end
end
