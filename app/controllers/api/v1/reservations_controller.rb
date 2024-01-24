class Api::V1::ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: %i[show update destroy add_item remove_item]
  before_action :set_user, only: %i[index show create update destroy]

  rescue_from CanCan::AccessDenied do |_exception|
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  # GET /api/v1/:username/reservations
  def index
    query = params[:query]
    @reservations = if query.present?
                      @user.reservations.search(query).includes(:items)
                    else
                      @user.reservations.includes(:items)
                    end

    render json: {
      status: { code: 200, message: 'Reservations retrieved successfully.' },
      data: @reservations.map do |reservation|
              ReservationSerializer.new(reservation).serializable_hash[:data][:attributes]
            end
    }, status: :ok
  end

  # GET /api/v1/reservations/:id
  def show
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    items = @reservation.items.paginate(page:, per_page:)
    serialized_items = items.map { |item| ItemSerializer.new(item).serializable_hash[:data][:attributes] }

    render json: {
      status: { code: 200, message: 'Reservation retrieved successfully.' },
      data: {
        reservation: ReservationshowSerializer.new(@reservation).serializable_hash[:data][:attributes],
        items: serialized_items
      },
      meta: {
        total_pages: items.total_pages,
        current_page: items.current_page,
        total_items: items.total_entries,
        per_page: items.per_page
      }
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

  # GET /api/v1/reservations/:id/items
  def items
    @items = @reservation.items

    render json: {
      status: { code: 200, message: 'Items retrieved successfully.' },
      data: @items.map { |item| ItemSerializer.new(item).serializable_hash[:data][:attributes] }
    }, status: :ok
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
