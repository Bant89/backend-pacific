# frozen_string_literal: true

class PhotosController < ApplicationController
  def update_user
    set_user
    if photo_params[:file]
      # Image coming from input type="file"
      @user.avatar.attach(photo_params[:file])
      photo = rails_blob_url(@user.avatar)
    else
      # When URL is given or raw Base64 data
      photo = photo_params[:photo]
    end
    json_response(@user) if @user.update!(avatar_url: photo)
  end

  def update_store
    set_store
    if photo_params[:file]
      # Image coming from input type="file"
      @store.image.attach(photo_params[:file])
      photo = rails_blob_url(@store.image)
    else
      # When URL is given or raw Base64 data
      photo = photo_params[:photo]
    end

    json_response(@store) if @store.update(image_url: photo)
  end

  def update_product
    set_product
    urls = []
    urls << photo_params[:images1] if photo_params[:images1].present?
    urls << photo_params[:images2] if photo_params[:images2].present?
    urls << photo_params[:images3] if photo_params[:images3].present?
    urls << photo_params[:images4] if photo_params[:images4].present?
    urls << photo_params[:images5] if photo_params[:images5].present?
    unless urls.empty?
      # Image coming from input type="file"
      @product.images.attach(urls)
      urls.clear
      @product.images.each do |image|
        image_url = rails_blob_url(image)
        urls << image_url
      end
      # else
      #   # When URL is given or raw Base64 data
      #   photo = photo_params[:photo]
    end
    byebug
    json_response(@product) if @product.update(images_url: urls)
  end

  private

  def photo_params
    params.permit(:id, :file, :photo, :images1, :images2, :images3, :images4, :images5)
  end

  def set_user
    @user = @current_user unless photo_params[:id].present?
    @user = User.find(photo_params[:id])
  end

  def set_store
    @store = Store.find(photo_params[:id]) unless photo_params[:id].nil?
  end

  def set_product
    @product = Product.find(photo_params[:id]) unless photo_params[:id].nil?
  end
end
