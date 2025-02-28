# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    
    if user.admin?
      # Administradores podem acessar tudo
      can :manage, :all
      # Adicione outras permissões específicas conforme necessário
    else
      # Usuários regulares não podem acessar o Active Admin
      cannot :access, :admin
    end

  end
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md
end
