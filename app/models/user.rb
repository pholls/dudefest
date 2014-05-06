class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
  process_in_background :avatar
  ROLES = %w[admin editor reviewer writer reader fake]

  after_initialize :set_user
  before_validation :sanitize

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, # :recoverable, 
         :rememberable, :trackable, :validatable

  validates :username, presence: true, length: { in: 4..28 }, uniqueness: true
  validates :name, presence: true, length: { in: 4..35 }
  validates :byline, uniqueness: true, allow_blank: true
  validates :role, presence: true
  validates :email, presence: true, uniqueness: :true, length: { in: 6..35 }
  validates :bio, uniqueness: true, allow_blank: true
  validates :avatar, presence: true, if: 'role?(:reviewer)'

  has_paper_trail
  has_many :tips, foreign_key: 'creator_id'
  has_many :events, foreign_key: 'creator_id'
  has_many :daily_videos, foreign_key: 'creator_id'
  has_many :things, foreign_key: 'creator_id'
  has_many :positions, foreign_key: 'creator_id'
  has_many :article_authors, foreign_key: 'author_id', dependent: :destroy,
                             inverse_of: :author
  has_many :articles, through: :article_authors
  has_many :created_articles, foreign_key: 'creator_id', class_name: 'Article'
  has_many :ratings, foreign_key: 'creator_id'
  has_many :quotes, foreign_key: 'creator_id'
  has_many :taglines, foreign_key: 'creator_id'
  has_many :titles, inverse_of: :user
  has_many :movies, foreign_key: 'creator_id', inverse_of: :creator
  has_many :comments, inverse_of: :user, dependent: :destroy

  rails_admin do
    object_label_method :username
    navigation_label 'Admin'
    configure :avatar, :jcrop

    list do
      sort_by :id
      field :username
      field :role do
        visible do
          User.current.role?(:admin)
        end
      end
      field :id do
        visible false
        sort_reverse false
      end

      field :tips_count do label 'Tip'; sort_reverse true; end
      field :daily_videos_count do label 'Vid'; sort_reverse true; end
      field :events_count do label 'His'; sort_reverse true; end
      field :things_count do label 'Thi'; sort_reverse true; end
      field :quotes_count do label 'Quo'; sort_reverse true; end
      field :articles_count do label 'Art'; sort_reverse true; end
      field :ratings_count do label 'Rat'; sort_reverse true; end
      field :movies_count do label 'Mov'; sort_reverse true; end
      field :comments_count do label 'Com'; sort_reverse true; end
      field :taglines_count do label 'Tag'; sort_reverse true; end

      include_fields :tips_count, :daily_videos_count, :events_count, 
                     :things_count, :articles_count do
        column_width 30
      end
      include_fields :quotes_count, :movies_count, :comments_count do
        column_width 40
      end
      include_fields :ratings_count, :taglines_count do
        column_width 35
      end
    end

    edit do
      include_fields :username, :name, :email
      field :twitter_handle do
        help 'Optional. Don\'t add the @ in front of it. Just do your user '\
             'name.'
      end
      include_fields :password, :password_confirmation
      field :avatar do
        jcrop_options aspectRatio: 400.0/400.0
        fit_image true
      end
      field :titles
      field :bio
      field :role do
        visible do
          User.current.role? :admin
        end
      end
      field :byline, :ck_editor do
        help ('Optional. Dudes need a byline. Just a bit about yourself.<br>'\
              'In any article you write, the byline will default to this.<br>'\
              'If you don\'t fill this out, you\'ll have to make a new byline '\
              'for each article you write.'
             ).html_safe
      end
    end
  end

  public
    def to_param; self.username; end

    def role?(base_role)
      ROLES.index(base_role.to_s) >= ROLES.index(role)
    end

    def role_enum
      ROLES
    end

    def public_articles
      self.articles.select { |a| a.public? }.sort_by { |a| a.date }
    end

    def last_name
      self.name.split.last
    end

    def display_avatar
      if self.avatar.present? 
        self.avatar.url(:display) 
      else
        "/mugshot#{(self.id % 5) + 1}.jpg"
      end
    end

    def self.current
      Thread.current[:current_user]
    end

    def self.current=(user)
      Thread.current[:current_user] = user
    end

    def self.fake_or(user)
      if user.present?
        self.where('role = ? or id = ?', 'fake', user.id).order(:id)
      end
    end

  private
    def set_user
      self.role ||= 'fake' if self.new_record?
    end

    def sanitize
      #Sanitize.clean!(self.name) if self.name.present?
      #Sanitize.clean!(self.username)
      Sanitize.clean!(self.email)
      if self.byline.present?
        Sanitize.clean!(self.byline, Sanitize::Config::BASIC)
      end
      self.name ||= self.username
    end
end
