class Rating < ActiveRecord::Base
  include ModelConfig, ItemReview, WeeklyOutput

  around_save :set_movie_total_rating
  after_initialize :initialize_creator
  before_validation :sanitize
  before_save :set_published_at

  has_paper_trail
  belongs_to :movie, inverse_of: :ratings, counter_cache: true
  has_one :review, through: :movie

  validates :body, presence: true, uniqueness: true, length: { in: 10..500 }
  validates :rating, presence: true, inclusion: { in: :rating_enum }
  validates :creator, uniqueness: { scope: :movie }
  validates :movie, presence: true

  default_scope { order(:id) }

  rails_admin do
    navigation_label 'Movies'
    parent Movie
    object_label_method :label_method
    configure :creator do
      label 'Rater'
      column_width 85
    end

    list do
      sort_by do
        'status_order_by, movie_id desc, ratings.created_at, ratings.creator_id'
      end
      include_fields :movie, :rating, :creator
      field :status_with_color do
        label 'Status'
        column_width 85
      end
      configure :rating do
        column_width 55
      end
    end

    edit do
      include_fields :movie, :creator, :body, :rating, :reviewed, 
                     :needs_work, :notes
      configure :creator do
        read_only true
      end
      configure :body do
        help ('Required. Between 10 and 500 characters.<br>'\
              'Try to say something that wasn\'t said in the review, '\
              'or in any of the other ratings.<br>'\
              'Feel free to poke fun at another one of the writers, '\
              'especially if they gave a movie a rating you disagree '\
              'with.<br>'\
              'Make sure you have a punchline in mind.').html_safe
      end
      include_fields :movie, :body, :rating, :reviewed, :needs_work do
        read_only do
          bindings[:object].class == Rating && bindings[:object].is_read_only?
        end
      end
      configure :needs_work do
        visible do
          bindings[:object].class == Rating && bindings[:object].failable?
        end
      end
      configure :reviewed do
        visible do
          bindings[:object].reviewable?
        end
      end
      field :weekly_output do
        read_only true
        help 'Rate your weekly ratings output on a scale of 1 to 2.'
      end
    end

    create do 
      include_fields :movie, :creator, :body, :rating, :reviewed, :notes,
                     :weekly_output do
        visible false
      end
      field :add_your_rating_elsewhere do
        read_only true
      end
    end

    nested do
      include_fields :movie, :weekly_output do
        visible false
      end
    end
  end

  public
    def initialize_creator
      self.creator ||= User.current if self.new_record?
    end

    def rating_enum
      (0..10).step(0.5).to_a.reverse
    end

    def display_rating
      self.rating == self.rating.to_i ? self.rating.to_i : self.rating
    end

    def add_your_rating_elsewhere
      'Add it to the actual movie so it relates to the review and other ratings'
    end

    def label_method
      if self.movie.present?
        self.creator.username + ' - ' + self.display_rating.to_s
      else
        'New Rating'
      end
    end

    def self.recent(x, user = nil)
      now = DateTime.now.in_time_zone('Eastern Time (US & Canada)').to_date
      conditions = { creator: user } if user.present?
      self.unscoped.where(conditions).where('published_at <= ?', now)
          .order(published_at: :desc).limit(x)
    end

    def generate_published_at
      if self.reviewed? && self.review.published?
        [self.review.date.try(:midnight), self.reviewed_at].max_by(&:to_i)
      else
        nil
      end
    end

  private
    def set_published_at
      self.published_at = generate_published_at()
    end

    def set_movie_total_rating
      yield
      if self.reviewed?
        self.movie.increment!(:total_rating, self.rating)
        self.movie.increment!(:reviewed_ratings)
      end
      if self.reviewed_was || self.marked_for_destruction?
        self.movie.decrement!(:total_rating, rating_was)
        self.movie.decrement!(:reviewed_ratings)
      end
    end

    def sanitize
      Sanitize.clean!(self.body)
    end
end
