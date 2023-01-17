module AuditEventHelper
  def audit_create_item(item)
    create_audit_event(item, :create_item)
  end

  def audit_request_lend(item)
    create_audit_event(item, :request_lend)
  end

  def audit_accept_lend(item)
    create_audit_event(item, :accept_lend)
  end

  def audit_request_return(item)
    create_audit_event(item, :request_return)
  end

  def audit_accept_return(item)
    create_audit_event(item, :accept_return)
  end

  def audit_add_to_waitlist(item)
    create_audit_event(item, :add_to_waitlist)
  end

  def audit_leave_waitlist(item)
    create_audit_event(item, :leave_waitlist)
  end

  private

  def create_audit_event(item, event_type)
    audit_event = AuditEvent.new(item: item, holder_id: item.holder,
                                 triggering_user: current_user, event_type: event_type)
    audit_event.save
  end
end
