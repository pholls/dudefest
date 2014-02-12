class Ability
  include CanCan::Ability

  def initialize(user)
    # user ||= User.new(role: 'reader')

    if user && user.role?(:writer)
      can :access, :rails_admin
      can :dashboard

      items = [Tip, Event, Position, Thing, DailyVideo, Rating, Quote]
      creatable_items = items
      creatable_items << Article << Movie << NameVariant << Dude
      readable_items = creatable_items
      readable_items << ThingCategory << User << Column << Genre << NameVariant

      can :new, creatable_items
      can :read, readable_items
      can :edit, items
      can :edit, Article do |article|
        article.creator == user && !article.finalized?
      end
      can :edit, Movie do |movie|
        !movie.review.finalized?
      end
      can :edit, User do |item|
        item == user
      end

      if user.role? :reviewer

      end

      if user.role? :editor
        can :edit, Article do |article|
          !article.finalized? && !article.edited_at.nil? ? article.editor == user : false
        end
      end

      if user.role? :admin
        can :manage, :all
      end
    end
  end
end
