class MapPermission < ApplicationRecord
  # Associations
  belongs_to :map
  belongs_to :user

  # Callbacks
  '''
  callbacks can be added here to execute processes after a certain action
  like running background jobs to send email invites for users to have access on maps
  or email notifications (or push notifications) after publishing a map or so

  after_create :send_invitation_by_email
  '''

  # Enums
  enum permission: { 1 => 'read', 2 => 'comment', 3 => 'write' }

  # Scopes
  scope :for_user, -> (user) { find_by_user_id(user.id) }

  # Validations
  validates_inclusion_of :access_level, in: MapPermission.permissions
end
