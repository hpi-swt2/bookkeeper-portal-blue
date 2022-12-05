# User model which has a first name, last name and full name
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :notifications, dependent: :destroy
  has_and_belongs_to_many :items, join_table: "wishlist"

  # Method expects all emails to follow format "firstname.lastname@anything" in order to extract first name out of email
  def first_name
    email.split("@")[0].split(".")[0].capitalize
  end

  def wishlist
    items
  end

  # Method expects all emails to follow format "firstname.lastname@anything" in order to extract last name out of email
  def last_name
    email.split("@")[0].split(".")[1].capitalize
  end

  def name
    "#{first_name} #{last_name}"
  end
end
