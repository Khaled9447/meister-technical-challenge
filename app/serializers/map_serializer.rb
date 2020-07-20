class MapSerializer < ActiveModel::Serializer
  attributes :title, :topic_id, :user

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
