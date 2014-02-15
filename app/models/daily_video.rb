class DailyVideo < ActiveRecord::Base
  include EasternTime, ModelConfig, ItemReview, DailyItem

  before_validation :sanitize

  has_paper_trail

  validates :title, presence: true, length: { in: 3..32 }, uniqueness: true
  validates :source, presence: true, uniqueness: true
  validates_formatting_of :source, using: :url
  validates :source, format: { with: /(youtube|metacafe|vimeo).com/, 
                               message: 'must be youtube, metacafe, or vimeo url' }

  auto_html_for :source do
    html_escape
    youtube
    metacafe
    vimeo
  end

  rails_admin do
    label 'Video'
    object_label_method :title
    navigation_label 'Daily Items'
    list do
      sort_by :date, :created_at
      include_fields :date, :title, :creator, :reviewed
      configure :date do
        strftime_format '%Y-%m-%d'
        column_width 75
      end
      configure :reviewed do
        column_width 75
      end
    end

    edit do
      include_fields :title, :source, :reviewed, :published do
        read_only do
          bindings[:object].is_read_only?
        end
      end
      field :source_html do
        label 'Video'
        read_only true
        visible false
        help false
      end
      include_fields :notes
      configure :reviewed do
        visible do
          bindings[:object].reviewable? && !bindings[:object].reviewed?
        end
      end
      configure :published do
        visible do
          bindings[:object].reviewed?
        end
      end
    end

    update do
      field :source_html do
        visible true
      end
    end

    show do
      field :title
      field :source_html
      field :creator
    end
  end

  private
    def sanitize
      Sanitize.clean!(self.title)
      Sanitize.clean!(self.source)
    end
end
