class Ability
  include CanCan::Ability

  def initialize(user)
    # user ||= User.new

    if user && user.role?(:writer)
      can :access, :rails_admin
      can :dashboard
      
      can :new, [Tip, Event, Position, Thing, Video, Article]
      can :read, [Tip, Event, Position, Thing, Video, Article]
      can :edit, [Tip, Event, Position, Thing, Video] do |item|
        item.try(:creator) == user && item.try(:editable?)
      end
      can :edit, Article do |article|
        article.author == user && !article.finalized?
      end
      can :read, [ThingCategory, User, Column]
      can :edit, User do |item|
        item == user
      end

      if user.role? :reviewer
        can :edit, [Tip, Event, Position, Thing, Video] do |item|
          item.try(:reviewable?) || (item.try(:creator) == user && item.try(:editable?))
        end
      end
      if user.role? :editor
        can :edit, Article do |article|
          !article.finalized? && !article.edited.nil? ? article.editor == user : true
        end
      end
      if user.role? :admin
        can :manage, :all
      end
    end
  end
end
