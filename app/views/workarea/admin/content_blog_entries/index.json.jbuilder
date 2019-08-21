json.results @search.results do |entry|
  json.id entry.id
  json.label entry.name
  json.value entry.id.to_s
end
