class ApplicationController < ActionController::API
  include Devise::JWT::Concerns::SetUserByToken
  load_and_authorize_resource

  respond_to :json
end
