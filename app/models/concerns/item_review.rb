module ItemReview
  extend ActiveSupport::Concern

  included do
    before_validation :complete_create
    before_validation :complete_review

    belongs_to :creator, class_name: 'User'
    belongs_to :reviewer, class_name: 'User'

    validates_associated :creator
    validates_associated :reviewer
    validates :creator, presence: true
    validates :reviewed, inclusion: { in: [false] }, on: :create
    validates :reviewed, inclusion: { in: [true, false] }, on: :update
  end

  public
    def reviewable?
      self.persisted? && self.creator != User.current
    end

    def editable?
      self.persisted? && !self.reviewed?
    end

  private
    def complete_create
      if self.new_record?
        self.reviewed = false
        self.creator = User.current
      end
    end

    def complete_review
      if reviewed? && reviewed_at.nil?
        self.reviewer = User.current
        self.reviewed_at = Time.now
      end
    end
end
