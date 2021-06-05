# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Feedback if user.is_a? BiMember
  end
end
