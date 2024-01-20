class ApplicationController < ActionController::API
  include Devise::JWT::Concerns::SetUserByToken
  # before_action :authenticate_user!, except: [:public_action]

  respond_to :json

  # def public_action
  # Code for public action
  # end

  # def private_action
  # Code for private action that requires authentication
  # end
end
