class Permission < ApplicationRecord
  belongs_to :item
  belongs_to :user_or_group, polymorphic: true
end
