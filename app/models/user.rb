class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validates :username, 
            presence: { message: "não pode ficar em branco" },
            uniqueness: { message: "já está sendo utilizado", case_sensitive: false }
            
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable
end
