class Video < ActiveRecord::Base
  include ItemReview, DailyItem

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
    object_label_method :title
    navigation_label 'Daily Items'
    list do
      sort_by :date, :created_at
      field :date do
        strftime_format '%Y-%m-%d'
      end
      field :title
      field :creator
      field :reviewed
    end

    edit do
      field :title
      field :source
      field :reviewed do
        visible do
          bindings[:object].reviewable?
        end
      end
    end

    show do
      field :title
      field :source_html
    end
  end
end
