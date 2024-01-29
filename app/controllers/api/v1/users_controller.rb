class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!

  rescue_from CanCan::AccessDenied do |_exception|
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  # GET /api/v1/users
  def index
    @users = User.all

    render json: {
      status: { code: 200, message: 'Users list retrieved successfully.' },
      data: @users.map { |user| UserSerializer.new(user).serializable_hash[:data][:attributes] }
    }, status: :ok
  end

  # GET /api/v1/users/:username
  def show
    @user = User.find_by(username: params[:username])

    if @user
      render json: {
        status: { code: 200, message: 'User information retrieved successfully.' },
        data: UserSerializer.new(@user).serializable_hash[:data][:attributes]
      }, status: :ok
    else
      render json: {
        status: 404,
        message: 'User not found.'
      }, status: :not_found
    end
  end

  # Get /api/v1/users/my_profile
  def my_profile
    render json: {
      status: { code: 200, message: 'User information retrieved successfully.' },
      data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
    }, status: :ok
  end

  # PATCH/PUT /api/v1/users/:username
  def update
    @user = User.find_by(username: params[:username])

    if @user && authorize_user(@user) && @user.update(user_params)
      render json: {
        status: { code: 200, message: 'Profile updated successfully.' },
        data: UserSerializer.new(@user).serializable_hash[:data][:attributes]
      }, status: :ok
    else
      render json: {
        status: 404,
        message: 'User not found or unauthorized to perform this action.',
        errors: @user&.errors&.full_messages
      }, status: :not_found
    end
  end

  # DELETE /api/v1/users/:username
  def destroy
    @user = User.find_by(username: params[:username])

    if @user && authorize_user(@user) && @user.destroy
      render json: {
        status: 200,
        message: 'User deleted successfully.'
      }, status: :ok
    else
      render json: {
        status: 404,
        message: 'User not found or unauthorized to perform this action.',
        errors: @user&.errors&.full_messages
      }, status: :not_found
    end
  end

  # /api/v1/:username/remove_admin
  def make_admin
    @user = User.find_by(username: params[:username])
    authorize! :make_admin, @user
    if @user
      @user.update(admin: true)
      render json: { message: "#{@user.username} is now an admin." }
    else
      render json: { error: 'User not found with the given username.' }, status: :not_found
    end
  end

  # /api/v1/:username/remove_admin
  def remove_admin
    @user = User.find_by(username: params[:username])
    authorize! :remove_admin, @user
    if @user
      @user.update(admin: false)
      render json: { message: "#{@user.username} is no longer an admin." }
    else
      render json: { error: 'User not found with the given username.' }, status: :not_found
    end
  end

  private

  def authorize_user(user)
    user == current_user
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :city, :email)
  end
end
