# Group Model which has a name and many members as well as owners
class Group < ApplicationRecord
  # if you want to promote or demote a user,
  # you will have to use the respective to_owner_of
  # or to_member_of methods from the user object
  # or remove that user from its previous collection
  # before appending it to the new collection
  # else you will get an ActiveRecord::RecordNotUnique error
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
