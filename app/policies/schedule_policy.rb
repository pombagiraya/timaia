class SchedulePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.role == 1
        scope.all
      else
        scope.where("user_id = ? OR room_id in (select room_id from rooms r inner join buildings b on r.building_id =  b.id where b.user_id = ? OR b.super_email = ?)", user, user.id, user.email)
      end
    end
  end

  def index?
    is_manager_or_admin_or_super_or_owner?
  end

  def new?
    true
  end

  def create?
    true
  end

  def update?
    is_manager_or_admin_or_super_or_owner?
  end

  def destroy?
    is_manager_or_admin_or_super_or_owner?
  end

  def edit?
    is_manager_or_admin_or_super_or_owner?
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
      user.role == 1 || record.where("room_id in (select room_id from rooms r inner join buildings b on r.building_id =  b.id where b.user_id = ? OR b.super_email = ?)", user.id, user.email)
    rescue
      user.role == 1 || record.room.building.user == user || record.room.building.super_email == user.email
    end
  end

  def is_manager_or_admin_or_super_or_owner?
    begin
      user.role == 1 || record.where("user_id = ? OR room_id in (select room_id from rooms r inner join buildings b on r.building_id =  b.id where b.user_id = ? OR b.super_email = ?)", user, user.id, user.email)
    rescue
      user.role == 1 || record.user == user || record.room.building.user == user || record.room.building.super_email == user.email
    end
  end

  def is_owner?
    user.role == 0
  end
end
