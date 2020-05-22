class BuildingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      #scope.all -- vou mostrar só os buildings do usuário
      scope.where(user: user)
    end
  end

  def index?
    is_owner_or_admin?
  end

  def new?
    user.role == 1
  end

  def create?
    user.role == 1
  end

  def update?
    is_owner_or_admin?
  end

  def destroy
    is_owner_or_admin?
  end

  def edit
    is_owner_or_admin?
  end

  private

  def is_owner_or_admin?
    record.user == user || user.role == 1
  end
end
