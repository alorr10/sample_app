User.create!(name:  "Alec Lorraine",
             email: "aleclorraine10@gmail.com",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = Faker::Internet.email
  password = Faker::Internet.password(6)
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
50.times do
  if rand < 0.50
    content = Faker::HarryPotter.quote[0..139]
  else
    content = Faker::ChuckNorris.fact[0..139]
  end
  users.each { |user| user.microposts.create!(content: content, created_at: Faker::Date.between(500.days.ago, Date.today)) }
end

# Following relationships
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow!(followed) }
followers.each { |follower| follower.follow!(user) }