class Api::V1::ItemsController < ApplicationController
  before_action :set_item, :username, only: %i[show update destroy]

  rescue_from CanCan::AccessDenied do |_exception|
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  # GET /api/v1/%23/items
  def index
    @items = Item.all
    items_attributes = if current_user.admin?
                         @items.map { |item| AdminItemSerializer.new(item).serializable_hash[:data][:attributes] }
                       else
                         @items.map { |item| ItemSerializer.new(item).serializable_hash[:data][:attributes] }
                       end

    render json: {
      status: { code: 200, message: 'Items retrieved successfully.', user: username },
      data: items_attributes
    }, status: :ok
  end

  # GET /api/v1/%23/items/:id
  def show
    render json: {
      status: { code: 200, message: 'Item retrieved successfully.', user: username },
      data: ItemSerializer.new(@item).serializable_hash[:data][:attributes]
    }, status: :ok
  end

  # POST /api/v1/%23/items
  def create
    @item = Item.new(item_params)

    if @item.save
      render json: {
        status: { code: 201, message: 'Item created successfully.', user: username },
        data: ItemSerializer.new(@item).as_json
      }, status: :created
    else
      render json: {
        status: 422,
        message: 'Validation failed.',
        errors: @item.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/%23/items/:id
  def update
    if @item.update(item_params)
      render json: {
        status: { code: 200, message: 'Item updated successfully.', user: username },
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
        status: { code: 200, message: 'Item deleted successfully.', user: username }
      }, status: :ok
    else
      render json: {
        status: 422,
        message: 'Failed to delete item.',
        errors: @item.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def username
    current_user&.username || '__guest__'
  end

  def item_params
    params.require(:item).permit(:name, :description, :other_attributes)
  end
end
