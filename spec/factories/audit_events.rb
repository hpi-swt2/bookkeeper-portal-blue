FactoryBot.define do
  factory :audit_event, class: 'AuditEvent' do
    item { nil }
    holder { nil }
    triggering_user { create(:user) }
    event_type { 1 }
  end
end
