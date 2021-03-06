class Article < ApplicationRecord
  include ModelConfig, ColumnSchedule, WeeklyOutput
  mount_uploader :image, ImageUploader
  process_in_background :image
  acts_as_commentable

  before_validation :initialize_article, on: :create
  before_validation :sanitize
  before_validation :substitute_references
  before_save :determine_status
  after_save :update_ratings_if_review
  after_save :send_emails
  after_destroy :destroy_movie_if_review

  has_paper_trail
  belongs_to :column, inverse_of: :articles, counter_cache: true
  belongs_to :topic, inverse_of: :articles, counter_cache: true
  belongs_to :creator, class_name: 'User'
  belongs_to :editor, class_name: 'User'
  belongs_to :reviewer, class_name: 'User'
  belongs_to :approver, class_name: 'User'
  belongs_to :movie, inverse_of: :review
  has_many :article_authors, dependent: :destroy, inverse_of: :article,
                             autosave: true
  has_many :authors, through: :article_authors

  validates :editor, presence: true, if: :approved?
  validates :title, presence: true, uniqueness: true, length: { in: 7..70 }
  validates :body, presence: true, uniqueness: true
  validates :column, :creator, presence: true
  validates :authors, presence: true, on: :update
  validates :topic, presence: true, unless: :is_movie_review?
  validates :image, presence: true, if: :created?
  validates :byline, presence: true
  validate :creator_is_author
  # No longer need more than 1 ratings
  # validate :review_has_enough_ratings

  accepts_nested_attributes_for :article_authors

  rails_admin do
    object_label_method :title
    navigation_label 'Articles'
    configure :image, :jcrop
    configure :article_authors do
      visible false
    end

    list do
      filters [:creator, :column, :editor]
      sort_by do
        'status_order_by, status desc, date desc, column_id, '\
         'creator_id, articles.created_at'
      end
      include_fields :date, :column, :title, :creator, :status, :editor
      configure :date do
        strftime_format '%Y-%m-%d'
        column_width 85
      end
      configure :column do
        column_width 70
      end
      configure :status do
        column_width 105
      end
      configure :creator do
        column_width 90
      end
      configure :editor do
        column_width 90
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
      include_fields :column, :title, :topic do
        read_only do
          article && article.movie.present?
        end
      end
      field :authors do
        orderable true
        associated_collection_scope do
          Proc.new { |scope| scope.with_role(:writer) }
        end
      end
      field :editor do
        visible do
          if current_user.has_role?(:editor) || current_user.has_role?(:admin)
            article && article.created
          else
            false
          end
        end
        associated_collection_scope do
          Proc.new { |scope| scope.with_role(:editor) }
        end
      end
      field :image do
        jcrop_options aspectRatio: 400.0/300.0
        fit_image true
      end
      field :remote_image_url
      field :body, :rich_editor do
        config( { insert_many: true, allow_embed: true } )
        help 'Required. This is where your actual article goes dumbass.'
      end
      field :byline, :ck_editor do
        help 'Required. If you don\'t like filling out a byline every time, '\
             'then fill out the byline on your user page.'
      end
      field :created do
        label 'Submit Draft'
        visible do
          article && article.creator == current_user && article.status < '1'
        end
        help 'Until you check this box, your article will just be a draft. '\
             'Check this box to submit your article for approval/editing'
      end
      field :approved do
        visible do
          current_user.has_role?(:approver) && article && article.status?('1 - Created')
        end
        help 'Check here if this article is all set to be edited.'
      end
      field :needs_rewrite do
        visible do
          current_user.has_role?(:approver) && article && article.status?('1 - Created')
        end
        help 'Is this article a piece of shit? Have the jackass who '\
             'submitted this piece of garbage rewrite it.'
      end
      field :finalized do
        visible do
          editor_or_admin = article.try(:editor) == current_user || current_user.has_role?(:admin)
          article && !article.reviewed && article.edited && editor_or_admin
        end
        help ('Checklist for finalizing an article:<br>'\
              '1. Make sure grammar, spelling, etc. are all set.<br>'\
              '2. Make sure the article has no extra space at the end.<br>'\
              '3. Make sure movies are all caps & TV shows are in italics.<br>'\
              '4. If it\'s a review, it needs to have >= 2 reviewed ratings.'\
              '<br>If those four conditions are not met, don\'t finalize the '\
              'article, or if it is finalized, uncheck it!'
             ).html_safe
      end
      field :reviewed do
        visible do
          if article
            available_reviewers = ::User.with_role(:reviewer) - [article.creator, article.editor]
          else
            available_reviewers = []
          end
          current_user.in?(available_reviewers) && article && article.finalized? && !article.reviewed?
        end
        help ('Checklist for finalizing an article:<br>'\
              '1. Make sure grammar, spelling, etc. are all set.<br>'\
              '2. Make sure the article has no extra space at the end.<br>'\
              '3. Make sure movies are all caps & TV shows are in italics.'
             ).html_safe
      end
      field :published do
        visible do
          article && article.reviewed? && current_user.has_role?(:admin)
        end
        help 'Schedule this article to be released. It best be good to go.'
      end
      field :date do
        visible do
          article && article.published? && current_user.has_role?(:admin)
        end
      end
      field :weekly_output do
        read_only true
        help 'Only mark it on your weekly output when you\'ve checked the '\
             'submit box. Always mark it when you\'ve check the submit box.'
      end
    end

    nested do
      include_fields :column, :title, :topic, :authors, :weekly_output do
        visible false
      end
    end

    create do
      configure :authors do
        visible false
      end
    end

    show do
      include_fields :column, :title, :topic, :authors, :status, :body
      configure :body do
        pretty_value do
          value.html_safe
        end
      end
    end
  end

  public
    def status?(base_status) base_status.to_s == self.status; end

    def display_title
      [self.column.article_append, self.title].reject(&:blank?).join(' ')
    end

    def is_movie_review?
      self.column.present? && self.column == Column.movie
    end

    def editable_by?(user)
      if user.has_role?(:editor)
        !self.edited? && self.editor == user && !self.finalized
      else
        self.authors.include?(user) && !self.finalized
      end
    end

    def display_date; self.date.strftime('%B %d, %Y'); end

    def type; self.column.short_name.upcase; end

    def display_image
      if self.image
        self.image_url(:display).to_s
      else
        self.column.image_url(:display).to_s
      end
    end

    def display_authors; self.authors.map(&:name).join(', '); end

    def author_and_date
      'By ' + self.display_authors + ' on ' + self.display_date
    end

    def can_edit?
      self.editor == current_user
    end

    def public?
      tz = 'Eastern Time (US & Canada)'
      self.published? && self.date <= DateTime.now.in_time_zone(tz).to_date
    end

    def self.public
      self.order(date: :desc, creator_id: :asc).select { |a| a.public? }
    end

    def self.public_articles
      self.order(date: :desc, creator_id: :asc).select { |a| a.public? }
           .select { |a| !a.is_movie_review? }
    end

    def author_ids=(ids)
      ids = ids.map(&:to_i).select { |i| i > 0 }
      unless ids == (current_ids = article_authors.map(&:author_id)) 
        (current_ids - ids).each { |id|
          article_authors.select { |aa|
            aa.author_id == id 
          }.first.mark_for_destruction
        }
        ids.each_with_index do |id, i|
          if current_ids.include? (id)
            article_authors.select { |aa| aa.author_id == id }.first.position = (i + 1)
          else
            article_authors.build( { author_id: id, position: (i + 1) } )
          end
        end
      end
    end

  private
    def initialize_article
      if self.new_record?
        self.creator ||= self.current_user
        self.article_authors.build(author: self.current_user, position: 1)
        self.created = false if self.created.nil?
        self.needs_rewrite = false if self.needs_rewrite.nil?
        self.finalized = false if self.finalized.nil?
        self.published = false if self.published.nil?
        self.reviewed = false if self.reviewed.nil?
        self.approved = false if self.approved.nil?
        self.status ||= '0 - Drafting'
        self.status_order_by ||= 0
        self.byline ||= self.creator.byline
      end
    end

    def determine_status
      if self.published? # 7 - Published
        self.published_at ||= Time.now
        self.date ||= self.assign_date()
        self.status = '7 - Published'
      elsif self.reviewed? # 6 - Reviewed
        self.status = '6 - Reviewed'
        self.reviewer = self.current_user if self.status_order_by == 5 # was final
      elsif self.finalized? # 5 - Finalized
        self.finalized_at ||= Time.now
        self.status = '5 - Finalized'
      elsif self.needs_rewrite? && self.created? # -1 - Rewrite
        self.approver = self.current_user
        self.created = self.needs_rewrite = false
        self.status = '-1 - Rewrite'
      elsif self.can_edit? && self.status > '2' # 3 - Edited
        self.edited_at = Time.now
        self.edited = true
        self.status = '3 - Edited'
      elsif self.edited? && self.finalized_was # 4 - Rejected
        self.status = '4 - Rejected'
        self.reviewer = self.current_user
      elsif self.edited? && self.creator == self.current_user # 4 - Responded
        self.responded_at = Time.now
        self.status = '4 - Responded'
      elsif self.approved? && self.current_user.has_role?(:approver) # 2 - Approved
        if !self.edited?
          self.approver = self.current_user
          self.status = '2 - Approved'
          self.editor ||= set_editor()
        end
      elsif self.created? && self.creator == self.current_user # 1 - Created
        self.status = '1 - Created'
      elsif self.creator == self.current_user # 0 - Drafting
        self.status = '0 - Drafting'
      end
      self.status_order_by = self.status.to_i
    end

    def destroy_movie_if_review
      self.movie.destroy if self.movie && !self.movie.destroyed?
    end

    def substitute_references
      writers = User.with_role :writer
      writers.find_each do |w|
        self.body.gsub!("[[#{w.name}]]",
                        create_link("/users/#{w.id}", w.name))
        self.body.gsub!("[[#{w.last_name}]]", 
                        create_link("/users/#{w.id}", w.last_name))
      end
    end

    def create_link(href, label)
      "<a href='#{href}'>#{label}</a>"
    end

    def creator_is_author
      unless article_authors.select { |aa| !aa.marked_for_destruction? }
                            .select { |aa| aa.author == self.creator }.present?
        errors.add(:authors, 'need to include the original author')
      end
    end

    def review_has_enough_ratings
      if self.is_movie_review? && self.movie.reviewed_ratings < 2
        if self.published? && ![1,7].include?(self.creator.id)
          errors.add(:column, 'needs at least 2 reviewed ratings')
        end
      end
    end

    def sanitize
      # self.title = Sanitize.fragment(self.title)
      # self.body = Sanitize.fragment(self.body, Sanitize::Config::RELAXED)
      self.byline = Sanitize.fragment(self.byline, Sanitize::Config::BASIC)

      self.body = self.body.gsub('<a href', '<a target="_blank" href')
      self.byline = self.byline.gsub('<a href', '<a target="_blank" href')

      strip_paragraphs = self.body.split(/\<\/p\>\s*\<p\>/)

      # if body has trailing whitespace, remove it
      if strip_paragraphs[-1].gsub('&nbsp;', '').strip == '</p>'
        begin
          strip_paragraphs.delete_at(-1)
        end while strip_paragraphs[-1].match(/[\s"&nbsp;"]*/)[0].present?
        self.body = strip_paragraphs.join("</p>\r\n\r\n<p>") + "</p>\r\n"
      end

      self.body = self.body.gsub(/(&nbsp;| )+/, ' ')
      self.body = self.body.gsub('<p> </p>', '<p>&nbsp;</p>')
    end

    def update_ratings_if_review
      if (self.published? || self.reviewed?) && self.is_movie_review?
        self.movie.ratings.each do |rating|
          if rating.persisted?
            rating.update_column :published_at, rating.generate_published_at
          end
        end
      end
    end

    def send_emails
      case self.status
      when '-1 - Rewrite'   then ArticleMailer.rewrite_email(self).deliver_later
      when  '1 - Created'   then ArticleMailer.created_email(self).deliver_later
      when  '2 - Approved'  then ArticleMailer.approved_email(self).deliver_later
      when  '3 - Edited'    then ArticleMailer.edited_email(self).deliver_later
      when  '4 - Responded' then ArticleMailer.responded_email(self).deliver_later
      when  '4 - Rejected'  then ArticleMailer.rejected_email(self).deliver_later
      when  '5 - Finalized' then ArticleMailer.finalized_email(self).deliver_later
      when  '6 - Reviewed'  then ArticleMailer.reviewed_email(self).deliver_later
      when  '7 - Published' then ArticleMailer.published_email(self).deliver_later
      end if self.status_changed?
    end
end
