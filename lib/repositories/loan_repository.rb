class LoanRepository
  def save(loan)
    raise NotImplementedError
  end

  def find(id)
    raise NotImplementedError
  end

  def active_loans_for_member(member_id)
    raise NotImplementedError
  end

  def find_active_loan_for_copy(copy_id)
    raise NotImplementedError
  end

  def next_identity
    raise NotImplementedError
  end
end

class InMemoryLoanRepository < LoanRepository
  def initialize
    @loans = {}
    @next_id = 1
  end

  def save(loan)
    @loans[loan.id] = loan
  end

  def find(id)
    @loans[id]
  end

  def active_loans_for_member(member_id)
    @loans.values.select { |loan| loan.member_id == member_id }
  end

  def find_active_loan_for_copy(copy_id)
    @loans.values.find { |loan| loan.copy_id == copy_id }
  end

  def next_identity
    id = @next_id
    @next_id += 1
    id
  end
end

