class BuildingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.role == 2
        scope.all
      else user.role == 1
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

  def import?
    is_manager_or_admin
  end

  private

  def is_manager_or_admin?
    user.role == 1 || user.role == 2
  end

  def no_access
    page_error_path
  end
end
