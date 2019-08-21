Workarea.configure do |config|
  config.seeds.insert_after('Workarea::CustomersSeeds', 'Workarea::BlogSeeds')
  config.seeds.insert_after('Workarea::BlogSeeds', 'Workarea::BlogEntrySeeds')
  config.seeds.insert_after('Workarea::BlogEntrySeeds', 'Workarea::BlogCommentSeeds')
end
