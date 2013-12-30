class Ability
  include CanCan::Ability

  def initialize(user)
    # user ||= User.new

    if user && user.role?(:writer)
      can :access, :rails_admin
      can :dashboard
      
      can :new, [Tip, Event, Position, Thing, DailyVideo, Movie, Article, Rating]
      can :read, [Tip, Event, Position, Thing, DailyVideo, Movie, Article, Rating]
      can :edit, [Tip, Event, Position, Thing, DailyVideo, Rating] do |item|
        item.try(:creator) == user && item.try(:editable?)
      end
      can :edit, Article do |article|
        article.author == user && !article.finalized?
      end
      can :edit, [Movie]
      can :read, [ThingCategory, User, Column, Genre, NameVariant]
      can :new, [NameVariant]
      can :edit, User do |item|
        item == user
      end

      if user.role? :reviewer
        can :edit, [Tip, Event, Position, Thing, DailyVideo, Rating]
      end
      if user.role? :editor
        can :edit, Article do |article|
          !article.finalized? && !article.edited_at.nil? ? article.editor == user : true
        end
      end
      if user.role? :admin
        can :manage, :all
      end
    end
  end
end
