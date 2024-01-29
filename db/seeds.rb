user = User.new(
  email:  's@g.c', #ENV['SUPER_ADMIN_EMAIL'],
  username: 's_admin', #ENV['SUPER_ADMIN_USERNAME'],
  super_admin: true,
  admin: true,
  first_name: 'Stanley', #ENV['SUPER_ADMIN_FIRST_NAME'],
  last_name: 'Osagie' #ENV['SUPER_ADMIN_LAST_NAME']
)

user.password = '123456' #ENV['SUPER_ADMIN_PASSWORD']
user.password_confirmation = '123456' #ENV['SUPER_ADMIN_PASSWORD']
user.save
