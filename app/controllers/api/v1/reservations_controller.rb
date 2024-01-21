class Api::V1::ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: %i[show update destroy]
  before_action :authorize_user_reservation, only: %i[show update destroy]
  before_action :authorize_admin, only: [:index_all]

  # GET /api/v1/reservations
  def index
    @reservations = current_user.reservations.includes(:items)

    render json: {
      status: { code: 200, message: 'Reservations retrieved successfully.' },
      data: @reservations.map { |reservation| ReservationSerializer.new(reservation).serializable_hash[:data] }
    }, status: :ok
  end

  # GET /api/v1/reservations/index_all
  def index_all
    @reservations = Reservation.includes(:items).all

    render json: {
      status: { code: 200, message: 'All Reservations retrieved successfully.' },
      data: ReservationSerializer.new(@reservations).serializable_hash[:data].map { |r| r[:attributes] }
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

  private

  def authorize_admin
    authorize! :read, Reservation
  end

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:reserve_for_use_date, :city, item_ids: [])
  end
end
