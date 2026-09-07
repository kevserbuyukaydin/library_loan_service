require_relative "../value_objects/money"

class FinePolicy
  def calculate(loan)
    raise NotImplementedError
  end
end

class DailyRateFinePolicy < FinePolicy
  DAILY_RATE = Money.of(100, "TRY")
  ZERO_FINE = Money.of(0, "TRY")

  def calculate(loan)
    return ZERO_FINE unless loan.overdue_at_return?
    DAILY_RATE * loan.overdue_days_at_return
  end
end