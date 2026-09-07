class ActivityLog
  def record(event)
    raise NotImplementedError
  end
end

class InMemoryActivityLog < ActivityLog
  def initialize
    @events = []
  end

  def record(event)
    @events << event
  end

  def events
    @events
  end
end