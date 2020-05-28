# frozen_string_literal: true

class PhotosController < ApplicationController
  def update_user
    set_user
    if params[:file]
      # Image coming from input type="file"
      @user.avatar.attach(params[:file])
      photo = rails_blob_url(@user.avatar)
    else
      # When URL is given or raw Base64 data
      photo = photo_params[:photo]
    end
    json_response(@user) if @user.update!(avatar_url: photo)
  end

  def update_store
    set_store
    if params[:file]
      # Image coming from input type="file"
      @store.image.attach(params[:file])
      photo = rails_blob_url(@store.image)
    else
      # When URL is given or raw Base64 data
      photo = photo_params[:photo]
    end

    json_response(@store) if @store.update(image_url: photo)
  end

  private

  def photo_params
    params.permit(:id, :file, :photo)
  end

  def set_user
    @user = @current_user unless photo_params[:id].present?
    @user = User.find(photo_params[:id])
  end

  def set_store
    @store = Store.find(photo_params[:id]) unless photo_params[:id].nil?
  end
end
