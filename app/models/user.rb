# User model which has a first name, last name and full name
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # This method expects all emails to follow the format "firstname.lastname@anything" in order to extract the first name out of the email
  def first_name
    email.split("@")[0].split(".")[0].capitalize
  end
  # This method expects all emails to follow the format "firstname.lastname@anything" in order to extract the last name out of the email
  def last_name
    email.split("@")[0].split(".")[1].capitalize
  end

  def name
    "#{first_name} #{last_name}"
  end
end
