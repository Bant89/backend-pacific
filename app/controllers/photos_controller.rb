# frozen_string_literal: true

class PhotosController < ApplicationController
  before_action :set_user
  def update
    if params[:file]
      # Image coming from input type="file"
      @user.avatar.attach(params[:file])
      photo = url_for(@user.avatar)
    else
      # When URL is given or raw Base64 data
      photo = photo_params[:photo]
    end

    json_response(@user) if @user.update(photo: photo)
  end

  private

  def photo_params
    params.permit(:id, :file, :photo)
  end

  def set_user
    @user = @current_user unless photo_params[:id].present?
    @user = User.find(photo_params[:id])
  end
end
