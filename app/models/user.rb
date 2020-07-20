class User < ApplicationRecord
  # Associations
  has_many :maps
  has_many :map_permissions
  has_many :permitted_maps, through: :map_permissions, source: "map"

  # Uploaders
  
  # upload user avatar (received as base64 from client side) and give it a name that is composed of
  #   user's name + word 'avatar' + a timestamp
  mount_base64_uploader :avatar, AvatarUploader, 
                         file_name: -> (u) { u.name + '-avatar-' + Time.now.to_i.to_s }

  # Validations
  validates_uniqueness_of :username
end
