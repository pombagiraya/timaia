class SchedulePolicy < ApplicationPolicy
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
    true
  end

  def new?
    true
  end

  def create?
    true
  end

  def update?
    is_manager_or_admin_owner?
  end

  def destroy?
    is_manager_or_admin_owner?
  end

  def edit?
    is_manager_or_admin_owner?
  end

  def show?
    true
  end

  def admin_view?
    is_manager_or_admin?
  end

  def owner_view?
    is_owner?
  end

  def user_schedules?
    true
  end
  
  private

  def is_manager_or_admin?
    user.role == 1 || user.role == 2
  end

  def is_manager_or_admin_owner?
    user.role == 1 || user.role == 2 || record.user == user
  end

  def is_owner?
    user.role == 0
  end
end
