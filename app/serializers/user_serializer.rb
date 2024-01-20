class UserSerializer
  include JSONAPI::Serializer
  attributes :first_name, :last_name, :city, :username, :email

  def attributes(*args)
    data = super
    data[:email] = @object.email if @object == current_user
    data
  end
end
