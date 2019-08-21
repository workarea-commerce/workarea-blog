json.results @search.results do |blog|
  json.label blog.name
  json.value blog.id.to_s
end
