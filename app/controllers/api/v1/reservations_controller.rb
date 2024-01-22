class Api::V1::ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: %i[show update destroy add_item remove_item]
  before_action :set_user, only: %i[index show create update destroy]

  rescue_from CanCan::AccessDenied do |_exception|
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  # GET /api/v1/:username/reservations
  def index
    @reservations = @user.reservations.includes(:items)

    render json: {
      status: { code: 200, message: 'Reservations retrieved successfully.' },
      data: @reservations.map { |reservation| ReservationSerializer.new(reservation).serializable_hash[:data] }
    }, status: :ok
  end

  # GET /api/v1/reservations/:id
  def show
    render json: {
      status: { code: 200, message: 'Reservation retrieved successfully.' },
      data: ReservationSerializer.new(@reservation).serializable_hash[:data][:attributes]
    }, status: :ok
  end

  # POST /api/v1/reservations
  def create
    @reservation = current_user.reservations.build(reservation_params)

    if @reservation.save
      render json: {
        status: { code: 201, message: 'Reservation created successfully.' },
        data: ReservationSerializer.new(@reservation).serializable_hash[:data][:attributes]
      }, status: :created
    else
      render json: {
        status: 422,
        message: 'Validation failed.',
        errors: @reservation.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/reservations/:id
  def update
    if @reservation.update(reservation_params)
      render json: {
        status: { code: 200, message: 'Reservation updated successfully.' },
        data: ReservationSerializer.new(@reservation).serializable_hash[:data][:attributes]
      }, status: :ok
    else
      render json: {
        status: 422,
        message: 'Validation failed.',
        errors: @reservation.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/reservations/:id
  def destroy
    if @reservation.destroy
      render json: {
        status: { code: 200, message: 'Reservation deleted successfully.' }
      }, status: :ok
    else
      render json: {
        status: 422,
        message: 'Failed to delete reservation.',
        errors: @reservation.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/reservations/:id/add_item
  def add_item
    item_id = params[:item_id].to_i
    @reservation.items << Item.find(item_id) unless @reservation.items.include?(item_id)

    render json: {
      status: { code: 200, message: 'Item added to reservation successfully.' },
      data: ReservationSerializer.new(@reservation).serializable_hash[:data][:attributes]
    }, status: :ok
  end

  # POST /api/v1/reservations/:id/remove_item
  def remove_item
    item_id = params[:item_id].to_i
    @reservation.items.delete(Item.find(item_id))

    render json: {
      status: { code: 200, message: 'Item removed from reservation successfully.' },
      data: ReservationSerializer.new(@reservation).serializable_hash[:data][:attributes]
    }, status: :ok
  end

  private

  def set_user
    username = params[:user_username]

    @user = User.find_by(username:)

    return if @user

    render json: { error: "User with username '#{username}' not found." }, status: :not_found
  end

  def authorize_admin
    current_user.admin?
  end

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:reserve_for_use_date, :city, item_ids: [])
  end
end
