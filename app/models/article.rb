class Article < ActiveRecord::Base
  before_validation :determine_status

  belongs_to :column
  belongs_to :author, class_name: 'User'
  belongs_to :editor, class_name: 'User'
  #has_one :movie

  validates_associated :column
  validates_associated :author
  validates_associated :editor, allow_blank: true
  validates :column_id, presence: true
  validates :title, presence: true, uniqueness: true, length: { in: 10..70 }
  validates :body, presence: true, uniqueness: true, length: { in: 500..10000 }

  rails_admin do
    object_label_method :title
    list do
      sort_by :date, :created_at
      field :date do
        strftime_format '%Y-%m-%d'
      end
      field :column
      field :title
      field :author
      field :editor
      field :status
    end
    edit do
      field :column
      field :title
      field :body, :ck_editor
      field :finalized do
        visible do
          bindings[:object].finalizable?
        end
      end
    end
    show do
      field :column
      field :title
      field :author
      field :status
      field :body do
        pretty_value do
          value.html_safe
        end
      end
    end
  end

  public
    def status?(base_status)
      base_status.to_s == self.status
    end

    def finalizable?
      !self.editor.nil? && self.editor == User.current
    end

  private
    def determine_status
      if self.new_record?
        self.finalized = false
        self.status = '1 - Created'
        self.author = User.current
      elsif self.finalized?
        self.status = '4 - Finalized'
        self.finalized_at = Time.now
      elsif self.editor.nil? || self.author != User.current
        self.status = '2 - Edited'
        self.editor = User.current
        self.edited_at = Time.now
      elsif self.responded_at.nil? || self.author == User.current
        self.status = '3 - Responded'
        self.responded_at = Time.now
        if self.class.select(:date).count > 0
          self.date = self.class.maximum(:date) + 1.day
        else
          self.date = Date.today
        end
      end
    end
end
