# user = User.create!(name: 'khaled', username: 'khaled9447')
# user = User.create!(name: 'Maged', username: 'maged9447')

# t1 = Topic.create!({ title: 'root topic 1', level: 0, parent_id: nil })
# t2 = Topic.create!({ title: 'root topic 2', level: 0, parent_id: nil })
# t3 = Topic.create!({ title: 'root topic 3', level: 0, parent_id: nil })

# Topic.create!([
#   { title: 't1', level: 1, parent_id: t1.id },
#   { title: 't2', level: 1, parent_id: t1.id },
#   { title: 't3', level: 2, parent_id: 5 },
#   { title: 't4', level: 2, parent_id: 5 },
#   { title: 't5', level: 2, parent_id: 5 },
# ])

# Map.create!([
#   { description: 'desc of root topic 1', user_id: user.id, topic_id: t1.id },
#   { description: 'desc of root topic 2', user_id: User.second.id, topic_id: t2.id },
#   { description: 'desc of root topic 3', user_id: User.second.id, topic_id: t3.id },
# ])
# MapPermission.create({ user_id: User.second.id, map_id: 1, access_level: 3 })

# ------- Using `Faker` gem to generate fake data -------

# Users
100.times do
  name = Faker::Name.name
  username = Faker::Name.unique.name
  User.create!(name: name, username: username)
end

# Root Topics (Maps)
100000.times do
  title = Faker::Games::Pokemon.name
  level = 0
  topic = Topic.create!(title: title, level: level)
  map = Map.create!(description: Faker::Games::Pokemon.move, user_id: rand(1..100), topic_id: topic.id)
  MapPermission.create({ user_id: rand(1..100), map_id: map.id, access_level: rand(1..3) })
end

# Non-root topics (children)
1000000.times do
  title = Faker::Games::Pokemon.name
  level = rand(1)
  parent_id = rand(1..1000)
  Topic.create!(title: title, level: level, parent_id: parent_id)
end