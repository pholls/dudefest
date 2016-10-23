class Ability
  include CanCan::Ability

  def initialize(user)
    # user ||= User.new

    if user && user.has_role?(:writer)
      can :access, :rails_admin
      can :dashboard

      items = [Tip, Event, Position, Thing, DailyVideo, Rating, Quote, Tagline]
      creatable_items = items
      creatable_items << Article << Movie << NameVariant << Dude << Title
      creatable_items << Comment
      readable_items = creatable_items
      readable_items << ThingCategory << User << Column << Genre << NameVariant
      readable_items << Topic

      can :new, creatable_items
      can :create, creatable_items, current_user_id: user
      can :read, readable_items
      can :edit, items
      can :update, items, current_user_id: user

      can :edit, Article do |article|
        article.editable_by(user)
      end
      can :update, Article do |article|
        article.editable_by(user) && article.current_user == user
      end

      can :edit, Movie do |movie|
        !movie.review.finalized? && movie.current_user == user
      end
      can :update, Movie do |movie|
        !movie.review.finalized?
      end

      can :edit, User do |item|
        item == user
      end

      if user.has_role?(:admin)
        can :manage, :all
      end
    end
  end
end
