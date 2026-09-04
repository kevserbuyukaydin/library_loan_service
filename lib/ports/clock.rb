require 'date'

class Clock
  def today
    raise NotImplementedError
  end
end

class SystemClock < Clock
  def today
    Date.today
  end
end

class FixedClock < Clock
  def initialize(fixed_date)
    @fixed_date = fixed_date
  end

  def today
    @fixed_date
  end
end