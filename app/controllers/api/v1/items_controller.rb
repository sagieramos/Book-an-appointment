class Api::V1::ItemsController < ApplicationController
  before_action :set_item, only: %i[show update destroy]
  before_action :set_user, only: [:index]

  rescue_from CanCan::AccessDenied do |_exception|
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  # GET /api/v1/:username/items
  def index
    per_page = params[:per_page] || 10
    page = params[:page] || 1
    query = params[:query]

    @items = if query.present?
               @user.items.search(query).includes(:reservations).paginate(page:, per_page:)
             else
               @user.items.includes(:reservations).paginate(page:, per_page:)
             end

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

  # GET /api/v1/:username/items/:id
  def show
    render json: {
      status: { code: 200, message: 'Item retrieved successfully.' },
      data: ItemSerializer.new(@item).serializable_hash[:data][:attributes]
    }, status: :ok
  end

  # POST /api/v1/:username/items
  def create
    @item = Item.new(item_params.merge(admin_id: current_user.id))

    if @item.save
      render json: {
        status: { code: 201, message: 'Item created successfully.' },
        data: ItemSerializer.new(@item).serializable_hash[:data][:attributes]
      }, status: :created
    else
      render json: {
        status: 422,
        message: 'Validation failed.',
        errors: @item.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/:username/items/:id
  def update
    if @item.update(item_params)
      render json: {
        status: { code: 200, message: 'Item updated successfully.' },
        data: ItemSerializer.new(@item).serializable_hash[:data][:attributes]
      }, status: :ok
    else
      render json: {
        status: 422,
        message: 'Validation failed.',
        errors: @item.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/items/:id
  def destroy
    if @item.destroy
      render json: {
        status: { code: 200, message: 'Item deleted successfully.' }
      }, status: :ok
    else
      render json: {
        status: 422,
        message: 'Failed to delete item.',
        errors: @item.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/items/:id/reservations
  def reservations
    @reservations = @item.reservations.includes(:customer).paginate(page: params[:page], per_page: params[:per_page])
    reservations_attributes = serialize_reservations(@reservations)

    render json: {
      status: { code: 200, message: 'Reservations retrieved successfully.' },
      data: reservations_attributes,
      meta: {
        total_pages: @reservations.total_pages,
        current_page: @reservations.current_page,
        per_page: @reservations.per_page,
        total_count: @reservations.total_entries
      }
    }, status: :ok
  end

  private

  def set_user
    username = params[:user_username]

    @user = User.find_by(username:)

    return if @user

    render json: { error: "User with username '#{username}' not found." }, status: :not_found
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(
      :name, :description, :image,
      :city, :finance_fee, :option_to_purchase_fee,
      :total_amount_payable,
      :duration, :apr_representative, reservation_id: []
    )
  end

  def serialize_items(items)
    if current_user.admin?
      items.map { |item| AdminItemSerializer.new(item).serializable_hash[:data][:attributes] }
    else
      items.map { |item| ItemSerializer.new(item).serializable_hash[:data][:attributes] }
    end
  end
end
