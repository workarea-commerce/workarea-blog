Workarea::Configuration.define_fields do
  fieldset 'Content', namespaced: false do
    field 'Blog Entry Index Display',
      id: :blog_entries_on_index,
      type: :integer,
      default: 4,
      description: 'The number of blog entries to display on the blog index page for each blog.'
  end
end
