class Movie < ActiveRecord::Base
  before_validation :set_review

  has_many :movie_genres, dependent: :destroy
  has_many :genres, through: :movie_genres
  has_one :review, class_name: 'Article', inverse_of: :movie, dependent: :destroy
  has_many :credits, dependent: :destroy, inverse_of: :movie # autosave: true
  has_many :name_variants, through: :credits
  has_many :ratings, inverse_of: :movie, dependent: :destroy

  validates_associated :review
  validates_associated :genres
  validates_associated :name_variants
  validates :title, presence: true, uniqueness: true, length: { in: 4..60 }
  validates :release_date, :review, :genres, :ratings, presence: true

  accepts_nested_attributes_for :review, :ratings, :credits

  rails_admin do
    object_label_method :title
    navigation_label 'Movies'
    configure :name_variants do
      label 'Dudes'
      orderable true
    end
    configure :credits do
      visible false
    end

    list do
      sort_by :title
      include_fields :title, :name_variants, :genres, :reviewed_ratings
      field :average_rating
    end

    edit do
      include_fields :title, :release_date, :genres, :name_variants
      include_fields :review, :ratings do
        active true
      end
    end
  end

  public
    def name_variant_ids=(ids)
      unless (ids = ids.map(&:to_i).select { |i| i > 0 }) == (current_ids = credits.map(&:name_variant_id)) 
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

  private
    def set_review
      if self.review.present?
        self.review.column = Column.movie if self.new_record?
        self.review.title = 'Review of ' + self.title
      end
    end

    def average_rating
      if self.reviewed_ratings.present? && self.reviewed_ratings > 0
        self.total_rating / self.reviewed_ratings
      else
        nil
      end
    end

end
