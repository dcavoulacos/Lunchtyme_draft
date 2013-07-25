json.array!(@users) do |user|
  json.extract! user, :name, :class_year, :res_college, :email, :phone, :gender, :facebook_id
  json.url user_url(user, format: :json)
end
