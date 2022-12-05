class Ownership < Membership
  default_scope -> { where(role: 'owner') }
end
