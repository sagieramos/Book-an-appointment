class Api::V1::Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  respond_to :json

  # def create
  # build_resource(sign_up_params)

  # if resource.save
  # render json: resource.as_json(except: %i[id created_at updated_at]), status: :created
  # else
  # clean_up_passwords resource
  #  render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
  # end
  # end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username first_name last_name city email])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name city])
  end

  def respond_with(resource, _opts = {})
    if request.method == 'POST' && resource.persisted?
      render json: {
        status: { code: 200, message: 'Signed up sucessfully.' },
        data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
      }, status: :ok
    elsif request.method == 'DELETE'
      render json: {
        status: { code: 200, message: 'Account deleted successfully.' }
      }, status: :ok
    else
      render json: {
        status: {
          code: 422,
          message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"
        }
      }, status: :unprocessable_entity
    end
  end

  # def sign_up(resource_name, resource)
  # Your custom sign-up logic here, if needed
  # super
  # end

  # def after_sign_up_path_for(resource)
  # Your custom logic for the path after sign-up
  # super(resource)
  # end

  # def after_inactive_sign_up_path_for(resource)
  # Your custom logic for the path after inactive sign-up
  #  super(resource)
  # end
end
