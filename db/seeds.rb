user = User.new(
  email: ENV['SUPER_ADMIN_EMAIL'],
  username: ENV['SUPER_ADMIN_USERNAME'],
  super_admin: true,
  first_name: ENV['SUPER_ADMIN_FIRST_NAME'],
  last_name: ENV['SUPER_ADMIN_LAST_NAME']
)

user.password = ENV['SUPER_ADMIN_PASSWORD']
user.password_confirmation = ENV['SUPER_ADMIN_PASSWORD']
user.save
