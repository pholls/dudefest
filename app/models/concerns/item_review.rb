module ItemReview
  extend ActiveSupport::Concern

  included do
    before_validation :complete_create, on: :create
    before_update :complete_review
    before_validation :sanitize_notes

    belongs_to :creator, class_name: 'User', counter_cache: true
    belongs_to :reviewer, class_name: 'User'

    validates_associated :creator
    validates_associated :reviewer
    validates :creator, presence: true
    validates :reviewed, inclusion: { in: [true, false] }
    validates :notes, length: { maximum: 1000 }
  end

  public
    def reviewable?
      self.persisted? && self.owner_or_admin?
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

  private
    def complete_create
      if self.new_record?
        self.reviewed = false
        self.creator = User.current
        self.notes ||= ''
      end
    end

    def complete_review
      if reviewed? && reviewed_at.nil?
        self.reviewer = User.current
        self.reviewed_at = Time.now
      end
    end

    def sanitize_notes
      Sanitize.clean!(self.notes)
    end
end
