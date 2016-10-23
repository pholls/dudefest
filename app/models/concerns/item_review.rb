module ItemReview
  extend ActiveSupport::Concern
  include CurrentUser

  included do
    before_validation :initialize_item, on: :create
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

    rails_admin do
      navigation_label 'Daily Items'
      configure :status_with_color do
        label 'Status'
        sortable :status_order_by
        searchable :status
        column_width 95
      end
      configure :creator do
        column_width 90
      end
      configure :needs_work do
        read_only { is_read_only? }
        visible do
          item_status_changeable? && object.status_order_by == 1
        end
      end
      configure :reviewed do
        read_only { is_read_only? }
        visible do
          item_status_changeable? && object.status_order_by >= 1
        end
      end
    end
  end

  public
    def down_class; self.class.name.underscore;     end
    def class_name; self.down_class.gsub('_', ' '); end

    def editable?
      self.persisted? && !self.reviewed?
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
        self.creator ||= self.current_user
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
        self.reviewer = self.current_user if !self.reviewed_was
        self.reviewed_at = Time.now  if !self.reviewed_was
        self.status = '2 - Reviewed'
      elsif self.needs_work? # -1 - Needs Work
        self.reviewer = self.current_user
        self.needs_work = false
        self.status = '-1 - Redo It'
      else # 1 - Created
        self.status = '1 - Created'
      end
      self.status_order_by = self.status.to_i
    end

    def send_emails
      case self.status_order_by
      when -1 then ItemMailer.needs_work_email(self).deliver_later
      when  1 then ItemMailer.created_email(self).deliver_later
      when  2 then ItemMailer.reviewed_email(self).deliver_later
      when  3 then ItemMailer.published_email(self).deliver_later
      end if self.status_changed? && !self.creator.has_role?(:owner, self.class)
    end

    def sanitize_notes
      self.notes = Sanitize.fragment(self.notes)
    end
end
