class ApartmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.role == 1
        scope.all
      else
        scope.where("user_id = ? OR building_id in (select building_id from buildings where user_id = ? OR super_email = ?)", user, user.id, user.email)
      end
    end
  end

  def index?
    is_owner?
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
    user.role == 1 || record.building.user == user
  end

  def is_manager_or_admin_or_super?
    user.role == 1 || record.building.user == user || record.building.super_email == user.email
  end

  def is_owner?
    user.role == 0
  end
end
