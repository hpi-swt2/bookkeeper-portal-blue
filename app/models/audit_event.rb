class AuditEvent < ApplicationRecord
  belongs_to :item
  belongs_to :holder, class_name: 'User', optional: true
  belongs_to :triggering_user, class_name: 'User'

  enum :event_type,
       { create_item: 0, request_lend: 10, accept_lend: 11, request_return: 20, accept_return: 21, deny_return: 22,
         add_to_waitlist: 30, leave_waitlist: 31 }
  validates :event_type, presence: true, inclusion: { in: event_types.keys }
end
