class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  ROLES = %w[admin editor reviewer writer reader]

  before_create :set_role

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username, presence: true, length: { in: 4..28 }, uniqueness: true
  validates :name, length: { in: 6..40 }, allow_blank: true

  has_many :tips, foreign_key: 'creator_id'
  has_many :reviewed_tips, class_name: 'Tip', foreign_key: 'reviewer_id'
  has_many :events, foreign_key: 'creator_id'
  has_many :reviewed_events, class_name: 'Tip', foreign_key: 'reviewer_id'
  has_many :videos, foreign_key: 'creator_id'
  has_many :reviewed_videos, class_name: 'Tip', foreign_key: 'reviewer_id'
  has_many :things, foreign_key: 'creator_id'
  has_many :reviewed_things, class_name: 'Tip', foreign_key: 'reviewer_id'
  has_many :positions, foreign_key: 'creator_id'
  has_many :reviewed_positions, class_name: 'Tip', foreign_key: 'reviewer_id'

  rails_admin do
    object_label_method :username
    list do
      sort_by :username
      field :username 
      field :tips_count do
        label 'Tips'
      end
      field :videos_count do
        label 'Videos'
      end
      field :positions_count do
        label 'Positions'
      end
      field :events_count do
        label 'Events'
      end
      field :things_count do
        label 'Things'
      end
    end

    edit do
      field :username
      field :name
      field :email
      field :password
      field :password_confirmation
      field :role do
        visible do
          User.current.role? :admin
        end
      end
    end
  end

  public
    def role?(base_role)
      ROLES.index(base_role.to_s) >= ROLES.index(role)
    end

    def role_enum
      ROLES
    end

    def self.current
      Thread.current[:current_user]
    end

    def self.current=(user)
      Thread.current[:current_user] = user
    end

  private
    def set_role
      self.role = ROLES.last
    end
end
