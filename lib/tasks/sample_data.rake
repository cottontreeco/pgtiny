namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_products
    make_reviews
    make_relationships
  end
end

def make_users
  #create example admin user
  admin = User.create!(name: "Example User",
               email: "example@railstutorial.org",
               password: "foobar",
               password_confirmation: "foobar",
               admin: true)

  #create 40 random user for pagination
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_products
  #create example product
  Product.create!(name: "Test Product")

  #create 40 random product for pagination
    40.times do |n|
      name  = Faker::Company.name
      Product.create!(name: name)
    end
end

def make_reviews
  #pick 36 users create 40 random product reviews
    users = User.limit(36)
    products = Product.all()
    40.times do |n|
      score = Faker::Number.between(1,5).round.to_s
      remark = Faker::Lorem.sentence(5)
      users.each{|user| user.reviews.create!(remark: remark, product: products[n])}
    end
end

def make_relationships
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followers = users[3..40]
  followed_users.each {|followed_user| user.follow!(followed_user)}
  followers.each {|follower| follower.follow!(user)}
end