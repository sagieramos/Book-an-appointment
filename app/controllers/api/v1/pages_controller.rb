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
    query = params[:query]

    items = fetch_items(private_user, query)

    paginated_items = items.paginate(page:, per_page:)
    items_attributes = serialize_items(paginated_items, current_user&.admin?)

    render_response('Pages Items', items_attributes, paginated_items)
  end

  def reservations
    per_page = params[:per_page] || 10
    page = params[:page] || 1
    private_user = params[:private_user] || false
    query = params[:query]

    reservations = if current_user.admin? && private_user
                     Reservation.includes(:items)
                   elsif query.present?
                     Reservation.search(query)
                   else
                     current_user.reservations.includes(:items)
                   end

    paginated_reservations = reservations.paginate(page:, per_page:)
    reservation_attributes = serialize_reservations(paginated_reservations)

    render_response('Reservations', reservation_attributes, paginated_reservations)
  end

  def users
    per_page = params[:per_page] || 10
    page = params[:page] || 1
    query = params[:query]

    users = if query.present?
              User.search(query)
            else
              User.all
            end

    paginated_users = users.paginate(page:, per_page:)
    user_attributes = serialize_users(paginated_users)

    render_response('Users', user_attributes, paginated_users)
  end

  def search
    query = params[:query]
    per_page = params[:per_page] || 10
    page = params[:page] || 1

    items = Item.search(query).paginate(page:, per_page:)

    reservations = Reservation.search(query).paginate(page:, per_page:)

    users = User.search(query).paginate(page:, per_page:)

    all_results = items + reservations + users

    serialize_results(all_results)

    paginated_reservations = reservations.paginate(page:, per_page:)
    attributes = serialize_results(all_results)
    render_response('Search result', attributes, paginated_reservations)
  end

  private

  def serialize_items(items, admin_user)
    serializer = admin_user ? AdminItemSerializer : ItemSerializer
    items.map do |item|
      additional_attributes = {}
      additional_attributes[:reservation_count] = item.reservations.count if admin_user
      if current_user
        additional_attributes[:you_reserve] =
          item.reservations.where(customer_id: current_user.id).count
      end
      attributes = serializer.new(item).serializable_hash[:data][:attributes]
      attributes.merge(additional_attributes)
    end
  end

  def serialize_reservations(reservations)
    reservations.map { |reservation| ReservationSerializer.new(reservation).serializable_hash[:data][:attributes] }
  end

  def serialize_users(users)
    users.map { |user| UserSerializer.new(user).serializable_hash[:data][:attributes] }
  end

  def render_response(message, data, paginated_data)
    render json: {
      status: { code: 200, message: "#{message} retrieved successfully." },
      data:,
      meta: {
        total_pages: paginated_data.total_pages,
        current_page: paginated_data.current_page,
        per_page: paginated_data.per_page,
        total_count: paginated_data.total_entries
      }
    }, status: :ok
  end

  def serialize_results(results)
    results.map do |result|
      serializer_class = case result
                         when Item
                           ItemSerializer
                         when Reservation
                           ReservationSerializer
                         when User
                           UserSerializer
                         end
      serializer_class.new(result).serializable_hash[:data] if serializer_class
    end.compact
  end

  def fetch_items(private_user, query)
    if private_user && query.present?
      current_user.items.search(query)
    elsif private_user
      current_user.items
    else
      Item.all
    end
  end
end
