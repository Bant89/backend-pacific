# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :email, :name, :is_admin, :avatar_url

  has_one :store

  def avatar_url
    # variant = object.avatar.variant(resize: '100x100')
    # rails_representation_url(variant, only_path: true)
    rails_blob_url(object.avatar) if object.avatar.attachment
  end
end
