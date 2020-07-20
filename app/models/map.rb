class Map < ApplicationRecord
  # Assocations
  belongs_to :topic
  belongs_to :user
  has_many :map_permissions

  # Callbacks
  '''
  callbacks can be added here to execute processes after a certain action
  like running background jobs to send email invites for users to have access on maps
  or email notifications (or push notifications) after publishing a map or so
  '''

  # Constants
  PER_PAGE = 5

  # Scopes
  ## usage of 'includes' to apply eager_loading (prevent n+1 problem)
  scope :published, -> { includes(:user, :topic).where(public: true) }
  scope :with_title, lambda { |title, level|
    includes(:topic).where(topics: { level: 0..level, title: title })
  }

  # Validations
  validates_presence_of :description

  # Methods

  def grant_access_for_user(user, access_level)
    # the value of access_level represents the permissions
    # (1: read, 2: comment, 3: write)
    map_permissions.find_or_initialize_by(user: user).update(access_level: access_level)
  end

  # checks if the passed user is either the owner of the map or have enough priviliges on it
  # to execute certain actions (like invite & public - no edit for now)
  def permitted_user? current_user
    ''' 
    for the sake of this challenge, the only privilige the user needs is to be the owner
    later, we can check for permissions like (write permission, share or invite)
    '''
    # checks if the owner is the current_user who requested the action
    self.user == current_user
  end

  # if the map is already public, then do nothing.
  def publish
    return true if self.public?
    
    self.update(public: true)
  end
end
