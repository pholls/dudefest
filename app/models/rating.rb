class Rating < ActiveRecord::Base
  include ModelConfig, ItemReview

  after_find :recall_old_state
  around_save :set_movie_total_rating
  after_initialize :initialize_creator
  before_validation :sanitize

  POSSIBLE_RATINGS = [10.0, 9.5, 9.0, 8.5, 8.0, 7.5, 7.0, 6.5, 6.0, 5.5, 5.0, 4.5, 4.0, 3.5, 3.0, 2.5, 2.0, 1.5, 1.0, 0.5, 0.0]

  belongs_to :movie, inverse_of: :ratings, counter_cache: true

  validates :body, presence: true, uniqueness: true, length: { in: 10..500 }
  validates :rating, presence: true, inclusion: { in: POSSIBLE_RATINGS }
  validates :creator, uniqueness: { scope: :movie }
  validates :movie, presence: true

  default_scope { order(:id) }

  rails_admin do
    navigation_label 'Movies'
    parent Movie
    object_label_method :label_method
    configure :creator do
      label 'Rater'
    end

    list do
      sort_by :movie
      include_fields :movie, :rating, :creator, :reviewed
    end

    edit do
      include_fields :movie, :creator, :body, :rating, :reviewed, :notes
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
      include_fields :movie, :body, :rating, :reviewed do
        read_only do
          bindings[:object].is_read_only?
        end
      end
      configure :reviewed do
        visible do
          bindings[:object].class == 'Rating' && bindings[:object].reviewable?
        end
      end
    end

    nested do
      configure :movie do
        visible false
      end
    end
  end

  public
    def initialize_creator
      if self.new_record?
        self.creator ||= User.current
      end
    end

    def rating_enum
      POSSIBLE_RATINGS
    end

    def display_rating
      self.rating == self.rating.to_i ? self.rating.to_i : self.rating
    end

    def label_method
      if self.movie.present?
        self.creator.username + ' - ' + self.display_rating.to_s
      else
        'New Rating'
      end
    end

  private
    def recall_old_state
      @old_rating = self.rating
      @was_reviewed = self.reviewed
    end

    def set_movie_total_rating
      yield
      if self.reviewed?
        self.movie.increment!(:total_rating, self.rating)
        self.movie.increment!(:reviewed_ratings)
      end
      if @was_reviewed || self.marked_for_destruction?
        self.movie.decrement!(:total_rating, @old_rating)
        self.movie.decrement!(:reviewed_ratings)
      end
    end

    def sanitize
      Sanitize.clean!(self.body)
    end
end
