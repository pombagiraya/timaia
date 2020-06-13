class BuildingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.role == 1
        scope.all
      else
        scope.where("user_id = ? OR super_email = ?", user, user.email)
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

  def import?
    is_managerowner_or_admin?
  end

  private

  def is_manager_or_admin?
    user.role == 1 || user.role == 2
  end

  def is_managerowner_or_admin?
    if user.role == 1 || user.role == 2
      begin
        user.role == 1 || record.where("user_id = ?", user)
      rescue
        user.role == 1 || record.user == user
      end
    end
  end

  def is_manager_or_admin_or_super?
    begin
      user.role == 1 || record.where("user_id = ? OR super_email = ?", user, user.email)
    rescue
      user.role == 1 || record.user == user || record.super_email == user.email
    end
  end

  def no_access
    page_error_path
  end
end
