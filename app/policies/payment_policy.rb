class PaymentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    true
  end

  def new?
    true
  end

  def create?
    is_manager_or_admin?
  end

  def update?
    is_manager_or_admin?
  end

  def destroy?
    is_manager_or_admin?
  end

  def edit?
    is_manager_or_admin?
  end

  def show?
    true
  end

  private

  def is_manager_or_admin?
    user.role == 1 || user.role == 2
  end
end
