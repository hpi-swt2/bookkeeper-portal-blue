# Group Model which has a name and many members as well as owners
class Group < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user

  has_many :ownerships, class_name: 'Ownership', dependent: :destroy
  has_many :owners, through: :ownerships, source: :user

  validate :owner?

  private

  def owner?
    errors.add(:base, "Group has to have an owner") if owners.empty?
  end
end
