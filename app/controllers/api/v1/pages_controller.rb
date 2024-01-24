class Api::V1::PagesController < ApplicationController
  before_action :authenticate_user!, except: [:items]

  respond_to :json

  rescue_from CanCan::AccessDenied do |_exception|
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  def items
    per_page = params[:per_page] || 10
    page = params[:page] || 1
    private_user = params[:private_user] || false

    @items = if private_user
               current_user.items.paginate(page:, per_page:)
             else
               Item.paginate(page:, per_page:)
             end

    items_attributes = serialize_items(@items, current_user&.admin?)

    render json: {
      status: { code: 200, message: 'Pages Items retrieved successfully.', user: username },
      data: items_attributes,
      meta: {
        total_pages: @items.total_pages,
        current_page: @items.current_page,
        per_page: @items.per_page,
        total_count: @items.total_entries
      }
    }, status: :ok
  end

  # GET /api/v1/p/reservations
  def reservations
    per_page = params[:per_page] || 10
    page = params[:page] || 1
    private_user = params[:private_user] || false

    reservations = if current_user.admin? && private_user
                     Reservation.paginate(page:, per_page:).includes(:items)
                   else
                     current_user.reservations.paginate(page:, per_page:).includes(:items)
                   end

    reservation_attributes = serialize_reservations(reservations)

    render json: {
      status: { code: 200, message: 'Reservations retrieved successfully.' },
      data: reservation_attributes,
      meta: {
        total_pages: reservations.total_pages,
        current_page: reservations.current_page,
        per_page: reservations.per_page,
        total_count: reservations.total_entries
      }
    }, status: :ok
  end

  # GET /api/v1/p/search_items
  def search_items
    per_page = params[:per_page] || 10
    page = params[:page] || 1
    query = params[:query]

    @items = Item.search(query).paginate(page:, per_page:)
    items_attributes = serialize_items(@items)

    render json: {
      status: { code: 200, message: 'Items retrieved successfully.' },
      data: items_attributes,
      meta: {
        total_pages: @items.total_pages,
        current_page: @items.current_page,
        per_page: @items.per_page,
        total_count: @items.total_entries
      }
    }, status: :ok
  end

  # GET /api/v1/p/search_reservations
  def search_reservations
    per_page = params[:per_page] || 10
    page = params[:page] || 1
    query = params[:query]

    @reservations = Reservation.search(query).paginate(page:, per_page:)
    reservation_attributes = serialize_reservations(@reservations)

    render json: {
      status: { code: 200, message: 'Reservations retrieved successfully.' },
      data: reservation_attributes,
      meta: {
        total_pages: @reservations.total_pages,
        current_page: @reservations.current_page,
        per_page: @reservations.per_page,
        total_count: @reservations.total_entries
      }
    }, status: :ok
  end

  # GET /api/v1/reservations/search_users
  def search_users
    per_page = params[:per_page] || 10
    page = params[:page] || 1
    query = params[:query]

    @users = User.search(query).paginate(page:, per_page:)
    user_attributes = serialize_users(@users)

    render json: {
      status: { code: 200, message: 'Users retrieved successfully.' },
      data: user_attributes,
      meta: {
        total_pages: @users.total_pages,
        current_page: @users.current_page,
        per_page: @users.per_page,
        total_count: @users.total_entries
      }
    }, status: :ok
  end

  private

  def username
    current_user&.username || '__guest__'
  end

  def serialize_items(items, admin_user)
    if admin_user
      items.map { |item| AdminItemSerializer.new(item).serializable_hash[:data][:attributes] }
    else
      items.map { |item| ItemSerializer.new(item).serializable_hash[:data][:attributes] }
    end
  end

  def serialize_reservations(reservations)
    reservations.map { |reservation| ReservationSerializer.new(reservation).serializable_hash[:data][:attributes] }
  end

  def authorize_user(user)
    current_user.admin? || current_user == user
  end
end
