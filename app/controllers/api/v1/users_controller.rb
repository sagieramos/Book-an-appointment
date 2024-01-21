class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!

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

  private

  def authorize_user(user)
    user == current_user
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :city, :email)
  end
end
