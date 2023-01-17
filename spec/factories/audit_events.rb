FactoryBot.define do
  factory :audit_event do
    item { nil }
    owner { nil }
    holder { nil }
    triggering_user { nil }
    event_type { 1 }
  end
end
