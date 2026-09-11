require_relative "../entities/loan"

class LoanService
  def initialize(member_repository:, book_repository:, loan_repository:, copy_repository:, clock:)
    @member_repository = member_repository
    @book_repository = book_repository
    @loan_repository = loan_repository
    @copy_repository = copy_repository
    @clock = clock
  end

  def borrow(member_id:, isbn:)
    member = find_member(member_id)
    ensure_book_exists(isbn)
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
end