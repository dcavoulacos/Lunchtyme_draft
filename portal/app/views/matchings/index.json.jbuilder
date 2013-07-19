json.array!(@matchings) do |matching|
  json.extract! matching, 
  json.url matching_url(matching, format: :json)
end