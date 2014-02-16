class User < ActiveRecord::Base
  ROLES = %w[admin editor reviewer writer reader]

  before_validation :sanitize

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
       # :registerable, :recoverable, 
         :rememberable, :trackable, :validatable

  validates :username, presence: true, length: { in: 4..28 }, uniqueness: true
  validates :name, presence: true, length: { in: 6..40 }
  validates :byline, presence: true, uniqueness: true
  validates :role, presence: true

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

  rails_admin do
    object_label_method :username
    navigation_label 'Users'

    list do
      sort_by :username
      include_fields :username, :role, :tips_count, :daily_videos_count
      include_fields :events_count, :things_count, :quotes_count
      include_fields :articles_count, :ratings_count
      field :reviews_count do
        sortable true
      end
      configure :role do
        visible do
          User.current.role?(:admin)
        end
      end
      configure :tips_count do
        label 'Tips'
        column_width 40
      end
      configure :daily_videos_count do
        label 'Videos'
        column_width 55
      end
      configure :events_count do
        label 'Events'
        column_width 55
      end
      configure :things_count do
        label 'Things'
        column_width 55
      end
      configure :quotes_count do
        label 'Quotes'
        column_width 60
      end
      configure :articles_count do
        label 'Articles'
        column_width 60
      end
      configure :ratings_count do
        label 'Ratings'
        column_width 60
      end
      configure :reviews_count do
        label 'Movies'
        column_width 60
      end
    end

    edit do
      include_fields :username, :name, :email, :password, :password_confirmation
      include_fields :password, :password_confirmation, :role
      configure :role do
        visible do
          User.current.role? :admin
        end
      end
      field :byline, :ck_editor do
        help ('Required. Dudes need a byline. Just a bit about yourself.<br>'\
              'In any article you write, the byline will default to this.'
             ).html_safe
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

    def reviews_count
      (count = self.articles.where.not(movie_id: nil).count) > 0 ? count : nil
    end

    def self.current
      Thread.current[:current_user]
    end

    def self.current=(user)
      Thread.current[:current_user] = user
    end

  private
    def sanitize
      Sanitize.clean!(self.name) if self.name.present?
      Sanitize.clean!(self.username)
      Sanitize.clean!(self.email)
      if self.byline.present?
        Sanitize.clean!(self.byline, Sanitize::Config::BASIC)
      end
    end
end
