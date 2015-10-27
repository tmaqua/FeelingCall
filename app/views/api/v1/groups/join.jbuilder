json.code "201"

json.users @users do |user|
  #json.id user.id
  #json.name user.name
  #json.sex user.sex
end

json.group do
  json.id @group.id
  json.name @group.name
end
