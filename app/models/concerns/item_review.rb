module ItemReview
  extend ActiveSupport::Concern

  included do
    after_initialize :initialize_item, on: :new
    before_validation :sanitize_notes
    before_save :determine_status
    after_save :send_emails

    belongs_to :creator, class_name: 'User', counter_cache: true
    belongs_to :reviewer, class_name: 'User'

    validates_associated :creator
    validates_associated :reviewer
    validates :creator, presence: true
    validates :reviewed, inclusion: { in: [true, false] }
    validates :notes, length: { maximum: 1000 }
  end

  public
    def down_class() self.class.name.underscore; end
    def class_name() down_class.gsub('_', ' '); end

    def reviewable?
      self.persisted? && self.owner_or_admin? && self.status_order_by >= 1
    end

    def failable?
      self.persisted? && self.owner_or_admin? && self.status_order_by == 1
    end

    def editable?
      self.persisted? && !self.reviewed?
    end

    def is_creator?
      self.creator == User.current
    end

    def is_read_only?
      if self.reviewed?
        !User.current.has_role?(:admin)
      else
        self.persisted? && !(self.is_creator? || self.owner_or_admin?)
      end
    end

    def status_with_color
      color =
        if status_order_by == -1 then 'red'
        elsif status_order_by == 1 then 'blue'
        elsif status_order_by == 2 && !try(:published).nil? && !published?
          'gold' # use gold for only daily items that can later be published
        else 'limegreen' end
      "<span style='color:#{color};'>#{status}</span>".html_safe
    end

  private
    def initialize_item
      if self.new_record?
        self.reviewed = false if self.reviewed.nil?
        self.needs_work = false if self.needs_work.nil?
        self.creator ||= User.current
        self.status ||= '0 - Drafting'
        self.status_order_by ||= 0
        self.notes ||= ''
      end
    end

    def determine_status
      if self.try(:published) # 3 - Published; daily items only
        self.published_at = Time.now if !self.published_was
        self.date ||= set_date()
        self.status = '3 - Published'
      elsif self.reviewed? # 2 - Reviewed
        self.reviewer = User.current if !self.reviewed_was
        self.reviewed_at = Time.now if !self.reviewed_was
        self.status = '2 - Reviewed'
      elsif self.needs_work? # -1 - Needs Work
        self.reviewer = User.current
        self.needs_work = false
        self.status = '-1 - Redo It'
      else # 1 - Created
        self.status = '1 - Created'
      end
      self.status_order_by = self.status.to_i
    end

    def send_emails
      case self.status_order_by
      when -1 then ItemMailer.needs_work_email(self).deliver
      when  1 then ItemMailer.created_email(self).deliver
      when  2 then ItemMailer.reviewed_email(self).deliver
      when  3 then ItemMailer.published_email(self).deliver
      end if self.status_changed? && !self.creator.has_role?(:owner, self.class)
    end

    def sanitize_notes
      Sanitize.clean!(self.notes)
    end
end
