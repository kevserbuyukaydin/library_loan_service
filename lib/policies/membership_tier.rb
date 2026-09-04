class MembershipTier
  def loan_period_days
    raise NotImplementedError
  end

  def max_loans
    raise NotImplementedError
  end

  def max_renewals
    raise NotImplementedError
  end

  def max_reservations
    raise NotImplementedError
  end
end

class StandardTier < MembershipTier
  def loan_period_days
    14
  end

  def max_loans
    3
  end

  def max_renewals
    1
  end

  def max_reservations
    2
  end
end

class PremiumTier < MembershipTier
  def loan_period_days
    30
  end

  def max_loans
    5
  end

  def max_renewals
    3
  end

  def max_reservations
    4
  end
end