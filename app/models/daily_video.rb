class DailyVideo < ApplicationRecord
  include EasternTime, ModelConfig, ItemReview, DailyItem, WeeklyOutput

  before_save :sanitize

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

    list do
      include_fields :date, :title, :source, :creator, :status_with_color
      configure :source do
        column_width 80
        pretty_value do
          "<a href='#{value}' target='_blank'>Video Link</a>".html_safe
        end
      end
    end

    edit do
      include_fields :title, :source do
        read_only { is_read_only? }
      end
      configure :source do
        help { bindings[:object].daily_video_help }
      end
      field :source_html do
        label 'Video'
        read_only true
        visible false
        help false
      end
      include_fields :reviewed, :needs_work, :published, :notes, :weekly_output
      field :current_user_id
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

  def label
    self.title
  end

  def daily_video_help
    ('<ul><li>Video should be under ten minutes long. '\
     'We don\'t want to bore people.</li>'\
     '<li>The video must be from youtube, metacafe, or vimeo. '\
     'We can\'t accepted videos from other sources.</li></ul>').html_safe
  end

  def weekly_output_help
    'Do it. You will.'
  end

  private
    def sanitize
      self.title  = Sanitize.fragment(self.title)
      self.source = Sanitize.fragment(self.source)
    end
end
