class Article < ActiveRecord::Base
  include ModelConfig

  before_validation :determine_status

  belongs_to :column, inverse_of: :articles, counter_cache: true
  belongs_to :author, class_name: 'User', counter_cache: true
  belongs_to :editor, class_name: 'User'
  belongs_to :movie, inverse_of: :review

  validates_associated :column
  validates_associated :author
  validates_associated :editor, allow_blank: true
  validates :column, presence: true
  validates :title, presence: true, uniqueness: true, length: { in: 10..70 }
  validates :body, presence: true, uniqueness: true, length: { in: 500..10000 }
  # The below line will change once we start releasing > one article a week
  validates :date, allow_blank: true, uniqueness: true

  rails_admin do
    object_label_method :title
    navigation_label 'Articles'
    list do
      sort_by :date, :created_at
      include_fields :date, :column, :title, :author, :editor, :status
      configure :date do
        strftime_format '%Y-%m-%d'
      end
    end
    edit do
      field :column do
        associated_collection_scope do
          Proc.new { |scope|
            scope = scope.where.not(column: Column.movie.column)
          }
        end
      end
      include_fields :column, :title do
        visible do
          bindings[:object].class == Article && bindings[:object].movie.nil?
        end
        read_only do
          bindings[:object].movie.present?
        end
      end
      field :body, :ck_editor
      field :finalized do
        visible do
          bindings[:object].class == Article && bindings[:object].finalizable?
        end
      end
    end
    show do
      include_fields :column, :title, :author, :status, :body
      configure :body do
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
      self.editor.present? && self.editor == User.current
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
        if self.class.select(:date).count > 0
          self.date = self.class.maximum(:date) + 1.day
        else
          self.date = Date.today
        end
      elsif self.editor.nil? || self.author != User.current
        self.status = '2 - Edited'
        self.editor = User.current
        self.edited_at = Time.now
      elsif self.responded_at.nil? || self.author == User.current
        self.status = '3 - Responded'
        self.responded_at = Time.now
      end
    end

    def is_movie_review?
      self.column.present? && self.column.column == Column.movie
    end
end
