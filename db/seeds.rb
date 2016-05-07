# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!( name:  "Example User", 
              email: "example@railstutorial.org",
              password:              "foobar",
              password_confirmation: "foobar", 
              admin: true,
              activated: true, 
              activated_at: Time.zone.now)
              
99.times do |n|
  
  # "NOTE: While Faker generates data at random, 
  # returned values are not guaranteed to be unique."
  # -https://github.com/stympy/faker
  name = Faker::Name.name
  email = "example-#{ n + 1 }@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
  
  # so this should have the first 6 users 
  # by order of creation
  users = User.order(:created_at).take(6)
  50.times do 
    # so i'm guessing when you access the faker::lorem#sentence
    # it keeps on accessing a random scentence
    content = Faker::Lorem.sentence(5)
    
  end
end
