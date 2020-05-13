# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :set_store
  before_action :set_store_product, only: %i[show update destroy]

  def index
    json_response(@store.products)
  end

  def show
    json_response(@product)
  end

  def create
    @store.products.create!(product_params)
    json_response(@store, :created)
  end

  def update
    @product.update(product_params)
    head :no_content
  end

  def destroy
    @product.destroy
    head :no_content
  end

  private

  def product_params
    params.require(:product).permit(:amount, :title, :price, :description, :category, :store_id)
  end

  def set_store
    @store = Store.find(params[:store_id])
  end

  def set_store_product
    @product = @store.products.find_by!(id: params[:id]) if @store
  end
end
