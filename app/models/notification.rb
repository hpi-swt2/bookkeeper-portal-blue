class Notification < ApplicationRecord
  actable

  belongs_to :user
end
