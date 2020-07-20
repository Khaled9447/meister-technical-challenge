class MyMapSerializer < ActiveModel::Serializer
  attributes :title, :topic_id, :access_level

  def title
    object.topic.title
  end

  # if the permission is nil (the map does not have permission entry for this user)
  # it means the user is the owner of the map
  def access_level
    permission = object.map_permissions.for_user(instance_options[:current_user]).try(:access_level)
    permission.nil? ? 'Owner' : MapPermission.permissions[permission].capitalize
  end
end
