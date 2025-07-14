# Clear existing data
Redemption.destroy_all
User.destroy_all
Reward.destroy_all

# Create admin user
admin = User.create!(
  email: "admin@thanx.com",
  password: "admin123",
  name: "Admin",
  admin: true,
  points_balance: 0
)

# Create regular user
user = User.create!(
  email: "tong@gmail.com",
  password: "user123",
  name: "Tong",
  admin: false,
  points_balance: 10000
)

# Create rewards
starbucks = Reward.create!(
  name: "Starbucks Gift Card",
  description: "$10 Starbucks gift card to enjoy your favorite coffee",
  cost: 500
)

walmart = Reward.create!(
  name: "Walmart Gift Card",
  description: "$25 Walmart gift card for your shopping needs",
  cost: 1000
)

iphone = Reward.create!(
  name: "iPhone 17 Pro",
  description: "Latest iPhone 17 Pro with 256GB storage",
  cost: 50000
)

puts "Seeded #{User.count} users and #{Reward.count} rewards"