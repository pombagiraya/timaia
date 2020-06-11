class ApartmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.role == 1 || user.role == 2
        scope.all
      else
        scope.where(user: user)
      end
    end
  end

  def index?
    is_manager_or_admin?
  end

  def new?
    is_manager_or_admin?
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

  def user_apartments?
    true
  end

  def admin_view?
    is_manager_or_admin?
  end

  def owner_view?
    is_owner?
  end

  def pay?
    true
  end
  
  private

  def is_manager_or_admin?
    user.role == 1 || user.role == 2
  end

  def is_owner?
    user.role == 0
  end
end
