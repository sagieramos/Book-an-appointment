class Api::V1::Users::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    login = params[:user][:login]
    password = params[:user][:password]

    if login.present?
      it_is_email = login.match?(Devise.email_regexp)
      authentication_key = it_is_email ? :email : :username

      resource = User.find_for_database_authentication({ authentication_key => login&.downcase })

      if resource&.valid_password?(password)
        sign_in(resource_name, resource)
        respond_with(resource)
      else
        render json: { error: 'Invalid login credentials' }, status: :unauthorized
      end
    else
      render json: { error: 'Login (email or username) is required' }, status: :unprocessable_entity
    end
  end

  protected

  def respond_with(resource, _opts = {})
    render json: {
      status: { code: 200, message: 'Logged in sucessfully.', current_user: current_user.username },
      data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
    }, status: :ok
  end

  def respond_to_on_destroy
    if current_user
      render json: {
        status: 200,
        message: 'logged out successfully'
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end
