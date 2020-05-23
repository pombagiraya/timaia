class ApartmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end

    def new?
      is_owner_or_admin
    end
  end

  private

  def is_owner_or_admin?
    record.user == user || user.admin
  end
end
