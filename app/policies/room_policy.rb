class RoomPolicy < ApplicationPolicy
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
    is_manager_or_admin_or_super?
  end

  def new?
    is_manager_or_admin?
  end

  def create?
    is_manager_or_admin?
  end

  def update?
    is_managerowner_or_admin?
  end

  def destroy?
    is_managerowner_or_admin?
  end

  def edit?
    is_managerowner_or_admin?
  end

  def show?
    true
  end
  
  private

  def is_manager_or_admin?
    user.role == 1 || user.role == 2
  end

  def is_managerowner_or_admin?
    user.role == 1 || record.building.user == user
  end

  def is_manager_or_admin_or_super?
    user.role == 1 || record.building.user == user || record.building.super_email == user.email
  end

end
