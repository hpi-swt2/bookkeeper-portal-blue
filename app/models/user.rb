# User model which has a first name, last name and full name
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
has_many :notifications, dependent: :destroy

  def first_name
    email.split("@")[0].split(".")[0].capitalize
  end

  def last_name
    email.split("@")[0].split(".")[1].capitalize
  end

  def name
    "#{first_name} #{last_name}"
  end
end
<<<<<<< HEAD
=======
  

>>>>>>> bb2ae613359d4d9ad9d9dc509f1596675ea532ca
