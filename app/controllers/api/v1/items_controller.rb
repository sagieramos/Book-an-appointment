class Api::V1::ItemsController < ApplicationController
  rescue_from CanCan::AccessDenied do |_exception|
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
