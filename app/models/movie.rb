class Movie < ActiveRecord::Base
  before_validation :set_review
  before_validation :sanitize

  has_many :movie_genres, dependent: :destroy
  has_many :genres, through: :movie_genres
  has_one :review, class_name: 'Article', inverse_of: :movie, dependent: :destroy
  has_many :credits, dependent: :destroy, inverse_of: :movie, autosave: true
  has_many :name_variants, through: :credits
  has_many :ratings, inverse_of: :movie, dependent: :destroy

  validates_associated :review
  validates_associated :genres
  validates_associated :ratings
  validates_associated :name_variants
  validates :title, presence: true, uniqueness: true, length: { in: 3..60 }
  validates :release_date, :review, :genres, :ratings, presence: true

  accepts_nested_attributes_for :review, :ratings, :credits

  rails_admin do
    object_label_method :title
    navigation_label 'Movies'
    configure :credits do
      visible false
    end

    list do
      sort_by :title
      include_fields :title, :reviewed_ratings
      field :unreviewed_ratings do
        sortable 'ratings_count - reviewed_ratings'
      end
      field :average_rating do
        sortable 'total_rating / reviewed_ratings'
      end
      include_fields :reviewed_ratings, :average_rating, :unreviewed_ratings do
        column_width 50
      end
    end

    edit do
      include_fields :title, :release_date, :genres, :name_variants
      configure :release_date do
        help 'Required. Should be the BoxOfficeMojo.com release date.'
      end
      configure :genres do
        help ('Required. Try to do at most two genres.<br>'\
              'Three is acceptable, but should be used sparingly.').html_safe
      end
      configure :name_variants do
        label 'Dudes'
        orderable true
        help ('Required. If there aren\'t any dudes in it, put N/A.<br>'\
              'If there are dudes in it, list them in order of importance.<br>'\
              'Feel free to list nicknames or pseudonyms or what not.<br>'\
              'Like Sir Nicholas Cage, The Fresh Prince, The guy from '\
              '_______, etc.').html_safe
      end
      include_fields :review, :ratings
      configure :review do
        active true
      end
      configure :ratings do
        active true
      end
    end
  end

  public
    def complete_ratings 
      self.ratings.select { |r| r.reviewed? }
    end 

    def title_with_year
      self.title.upcase + ' (' + self.release_date.year.to_s + ')'
    end

    def author_and_date
      r = self.review
      'Reviewed by ' + r.display_authors + '<br>on ' + r.display_date
    end

    def average_rating
      if self.reviewed_ratings.present? && self.reviewed_ratings > 0
        '%.2f' % (self.total_rating / self.reviewed_ratings)
      else
        nil
      end
    end

    def unreviewed_ratings
      self.ratings_count.to_i - self.reviewed_ratings.to_i 
    end
    
    def name_variant_ids=(ids)
      ids = ids.map(&:to_i).select { |i| i > 0 }
      unless ids == (current_ids = credits.map(&:name_variant_id)) 
        (current_ids - ids).each { |id|
          credits.select { |c| 
            c.name_variant_id == id 
          }.first.mark_for_destruction
        }
        ids.each_with_index do |id, i|
          if current_ids.include? (id)
            credits.select { |c| c.name_variant_id == id }.first.position = (i + 1)
          else
            credits.build( { name_variant_id: id, position: (i + 1) } )
          end
        end
      end
    end

    def self.finalized
      self.includes(:review).order('articles.date desc')
                            .select { |m| m.review.public? }
    end

  private
    def set_review
      if self.review.present?
        self.review.column = Column.movie if self.new_record?
        self.review.title = 'Review of ' + self.title
      end
    end

    def sanitize
      Sanitize.clean!(self.title)
    end

end
