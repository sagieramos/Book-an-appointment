class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Item

    return unless user.present?

    can %i[create read update destroy], User, id: user.id
    can :manage, Reservation, customer_id: user.id

    return unless user.admin? || user.super_admin?

    can :read, User
    can :read, Reservation
    can :manage, Item

    return unless user.super_admin?

    can :manage, :all

    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md
  end
end
