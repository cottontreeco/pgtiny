namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
  #create example admin user
    User.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar",
                 admin: true)
  #create example product
    Product.create!(name: "Test Product")
  #create 40 random user for pagination
    40.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  #create 40 random product for pagination
    40.times do |n|
      name  = Faker::Company.name
      Product.create!(name: name)
    end
  #pick 36 users create 40 random product reviews
    users = User.all(limit: 36)
    products = Product.all()
    40.times do |n|
      remark = Faker::Lorem.sentence(5)
      users.each{|user| user.reviews.create!(remark: remark, product: products[n])}
    end
  end
end