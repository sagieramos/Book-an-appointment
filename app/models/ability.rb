class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Item

    # Define abilities for the user here. For example:
    #
    return unless user.present?

    # Regular users can manage their own profile and reservations they created
    can %i[create read update destroy], User, id: user.id
    # can :manage, User, id: user.id
    can :manage, Reservation, customer_id: user.id

    return unless user.admin?

    can :read, [User, Reservation]
    can :manage, Item

    return unless user.super_admin?

    can %i[make_admin remove_admin], User
    can :manage, :all

    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md
  end
end
