module StatisticsHelper
  # Module for generating and collecting statistics.
  # Please let your helper function start with "statistics_"

  # Please keep the documentaion up to date:
  # https://github.com/hpi-swt2/bookkeeper-portal-blue/wiki/Statistics

  def statistics_item_popularity(item)
    lend_events = item_lend_events(item)
    return_events = item_return_events(item)
    avg_lend_duration = average_lend_duration(lend_events, return_events)

    # add 1 to every factor to avoid the result being 0
    ((lend_events.length + 1) * (avg_lend_duration + 1) *
    (item.waitlist_length + 1)) / (item.age.nonzero? or 1)
  end

  private

  def item_lend_events(item)
    AuditEvent.where(
      item: item,
      event_type: :accept_lend
    ).order(created_at: :asc)
  end

  def item_return_events(item)
    AuditEvent.where(
      item: item,
      event_type: :accept_return
    ).order(created_at: :asc)
  end

  def average_lend_duration(lend_events, return_events)
    durations = lend_events.zip(return_events)
                           .delete_if { |l, r| l.nil? or r.nil? }
                           .collect { |l, r| (r.created_at - l.created_at).seconds }
    durations.sum / (durations.size.nonzero? or 1)
  end
end
