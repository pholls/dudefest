class Comment < ActiveRecord::Base
  include WeeklyOutput
  
  acts_as_nested_set scope: [:commentable_id, :commentable_type]

  validates :body, presence: true
  validates :user, presence: true

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_votable

  belongs_to :commentable, polymorphic: true

  # NOTE: Comments belong to a user
  belongs_to :user, inverse_of: :comments, counter_cache: true
  belongs_to :creator, class_name: User, inverse_of: :comments

  auto_html_for :body do
    html_escape
    link
  end

  rails_admin do
    object_label_method :body
    navigation_label 'Articles'
    parent Article
    configure :commentable do
      label 'Article'
    end
    configure :body do
      label 'Comment'
    end

    list do
      sort_by :created_at
      include_fields :commentable, :user, :body, :created_at
      configure :user do
        column_width 85
      end
      configure :created_at do
        strftime_format '%Y-%m-%d %H:%M'
        column_width 115
      end
    end

    edit do
      include_fields :commentable, :body
      field :weekly_output do
        read_only true
        help 'Even comments deserve to be in weekly output'
      end
    end
    
    show do
      include_fields :commentable, :user, :created_at
      field :body_html
    end
  end

  # Helper class method that allows you to build a comment
  # by passing a commentable object, a user_id, and comment text
  # example in readme
  def self.build_from(obj, user, comment)
    self.new(commentable: obj, body: comment, user: user)
  end

  #helper method to check if a comment has children
  def has_children?
    self.children.any?
  end

  # Helper class method to lookup all comments assigned
  # to all commentable types for a given user.
  scope :find_comments_by_user, lambda { |user|
    where(:user_id => user.id).order('created_at DESC')
  }

  # Helper class method to look up all comments for
  # commentable class name and commentable id.
  scope :find_comments_for_commentable, lambda { |commentable_str, commentable_id|
    where(:commentable_type => commentable_str.to_s, :commentable_id => commentable_id).order('created_at DESC')
  }

  def find_commentable
    self.commentable_type.constantize.find(self.commentable_id)
  end

  def self.recent(x, user = nil)
    conditions = { user: user } if user.present?
    self.where(conditions).order(created_at: :desc).first(x)
  end

  # Helper class method to look up a commentable object
  # given the commentable class name and id
  def self.find_commentable(commentable_str, commentable_id)
    commentable_str.constantize.find(commentable_id)
  end
end
