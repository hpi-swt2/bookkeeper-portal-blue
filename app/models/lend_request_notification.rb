class LendRequestNotification < ApplicationRecord
  belongs_to :borrower, class_name: "User"
  belongs_to :item
end
