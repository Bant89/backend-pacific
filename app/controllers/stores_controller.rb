# frozen_string_literal: true

class StoresController < ApplicationController
  before_action :set_store, only: %i[show update destroy]

  # GET /store
  def index
    @stores = Store.all
    json_response(@stores)
  end

  # POST /store
  def create
    @store = Store.create!(store_params)
    json_response(@store, :created)
  end

  # GET /store/:id
  def show
    json_response(@store)
  end

  # PUT /store/:id
  def update
    @store.update(store_params)
    head :no_content
  end

  # DELETE /store/:id
  def destroy
    @store.destroy
    head :no_content
  end

  private

  def store_params
    params.permit(:title, :created_by, :description, :category, :image)
  end

  def set_store
    @store = Store.find(params[:id])
  end
end
