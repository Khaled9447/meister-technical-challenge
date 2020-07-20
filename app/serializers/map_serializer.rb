class MapSerializer < ActiveModel::Serializer
  attributes :id, :title, :user

  def title
    object.topic.title
  end

  def user
    {
      name: object.user.name,
      avatar: object.user.avatar
    }
  end
end
