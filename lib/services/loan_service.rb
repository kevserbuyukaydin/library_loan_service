require_relative "../entities/loan"

class LoanService
  def initialize(member_repository:, book_repository:, loan_repository:, copy_repository:, borrowing_eligibility_policy:, clock:)
    @member_repository = member_repository
    @book_repository = book_repository
    @loan_repository = loan_repository
    @copy_repository = copy_repository
    @borrowing_eligibility_policy = borrowing_eligibility_policy
    @clock = clock
  end

  def borrow(member_id:, isbn:)
    member = find_member(member_id)
    ensure_book_exists(isbn)
    ensure_loan_limit_not_exceeded(member)
    ensure_eligible_to_borrow(member)
    copy = find_available_copy(isbn)
    today = @clock.today

    create_loan(member: member, copy: copy, member_id: member_id, today: today)
  end

  private

  def ensure_book_exists(isbn)
    book = @book_repository.find(isbn)
    raise BookNotFoundError.new(isbn) if book.nil?
  end

  def find_member(member_id)
    member = @member_repository.find(member_id)
    raise MemberNotFoundError.new(member_id) if member.nil?
    member
  end
  
  def find_available_copy(isbn)
    copy = @copy_repository.available_copy_for(isbn)
    raise NoCopiesAvailableError.new(isbn) if copy.nil?
    copy
  end

  def calculate_due_date(member, today)
    today + member.tier.loan_period_days
  end

  def create_loan(member:, copy:, member_id:, today:)
    loan = Loan.new(
      id: @loan_repository.next_identity,
      copy_id: copy.id,
      member_id: member_id,
      borrowed_on: today,
      due_date: calculate_due_date(member, today)
    )
    @loan_repository.save(loan)
    copy.loan!
    @copy_repository.save(copy)

    loan
  end

  def ensure_loan_limit_not_exceeded(member)
    active_loans_count = @loan_repository.active_loans_for_member(member.id).size
    raise LoanLimitExceededError.new(member.id, member.tier.max_loans) if active_loans_count >= member.tier.max_loans
  end

  def ensure_eligible_to_borrow(member)
    raise OutstandingFinesError.new(member.id) unless @borrowing_eligibility_policy.eligible?(member.id)
  end
end