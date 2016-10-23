# RailsAdmin config file. Generated on November 24, 2013 19:57
# See github.com/sferik/rails_admin for more informations

RailsAdmin.config do |config|
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.authorize_with :cancan
  docs = 'https://docs.google.com/'
  wo = docs + 'spreadsheet/ccc?key=0AvXIsPBDZM-VdFNscld1YVBGTjdORG1pNTNFbFkxc1E'
  ideas = docs + 'document/d/1AH0SZQJH2QzwfZFcGCBbdTiZHUSCGvRTvUbCp_XC1WU'
  config.navigation_static_links = { 
    'Weekly Output' => wo, 'Article Ideas' => (wo + '#gid=7'),
    'Dudefest Ideas' => ideas,
    'Reddit Posts' => 'http://www.reddit.com/domain/dudefest.com'
  }

  INCLUDED = %w(User Tip Event Position ThingCategory Thing DailyVideo Article
                Column Genre NameVariant Movie Rating Model Quote Dude Tagline
                Topic Title Comment Fact Role)

  ################  Global configuration  ################

  # Set the admin name here (optional second array element will appear in red). For example:
  config.main_app_name = ['Dudefest', 'Douchebag Central (Admin Page)']

  # RailsAdmin may need a way to know who the current user is]
  config.current_user_method(&:current_user) # auto-generated

  # If you want to track changes on your models:
  INCLUDED.each do |model|
    config.audit_with :paper_trail, model, 'PaperTrail::Version'
  end

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, 'User'

  # Display empty fields in show views:
  # config.compact_show_view = false

  # Number of default rows per-page:
  config.default_items_per_page = 200

  # Exclude specific models (keep the others):
  # config.excluded_models = ['Event', 'Position', 'Thing', 'ThingCategory', 'Tip', 'User', 'Video']

  #config.excluded_models =
  #Dir.glob(Rails.root.join('app/models/concerns/**.rb')).map { |p| 
  #  'Concerns::' + File.basename(p, '.rb').camelize
  #}

  config.included_models = INCLUDED

  config.parent_controller = '::ApplicationController'

  def current_user
    bindings[:view].current_user
  end

  def object
    bindings[:object]
  end

  def is_read_only?
    if object.try(:reviewed?)
      !current_user.has_role?(:admin)
    else
      object.persisted? && !(is_creator? || owner_or_admin?)
    end
  end

  def is_creator?
    object.try(:creator) == bindings[:view].current_user
  end

  def owner_or_admin?(obj = object)
    owner = obj.class.try(:owner)
    owner == current_user || current_user.has_role?(:admin)
  end

  def item_status_changeable?
    object.class.included_modules.include?(ItemReview) &&
      object.persisted? && owner_or_admin?
  end

  def article
    object.is_a?(Article) ? object : object.try(:review)
  end
end
