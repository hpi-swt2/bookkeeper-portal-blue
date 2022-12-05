class Group < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships

  has_many :ownerships, class_name: 'Ownership', dependent: :destroy
  has_many :owners, through: :ownerships, source: :user
end
