class Notifier
  def notify(member_id, copy)
    raise NotImplementedError
  end
end

class InMemoryNotifier < Notifier
  def initialize
    @notifications = []
  end

  def notify(member_id, copy)
    @notifications << { member_id: member_id, copy_id: copy.id, notified_at: Time.now }
  end

  def notifications_for(member_id)
    @notifications.select { |n| n[:member_id] == member_id }
  end
end