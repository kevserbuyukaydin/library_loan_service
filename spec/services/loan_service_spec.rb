require_relative "../../lib/services/loan_service"
require_relative "../../lib/repositories/member_repository"
require_relative "../../lib/repositories/book_repository"
require_relative "../../lib/repositories/copy_repository"
require_relative "../../lib/repositories/loan_repository"
require_relative "../../lib/repositories/fine_repository"
require_relative "../../lib/repositories/reservation_repository"
require_relative "../../lib/entities/member"
require_relative "../../lib/entities/book"
require_relative "../../lib/entities/copy"
require_relative "../../lib/entities/fine"
require_relative "../../lib/policies/membership_tier"
require_relative "../../lib/policies/borrowing_eligibility_policy"
require_relative "../../lib/value_objects/money"
require_relative "../../lib/ports/clock"
require_relative "../../lib/errors"

RSpec.describe LoanService do
  describe "#borrow" do
    let(:member_repo) { InMemoryMemberRepository.new }
    let(:book_repo) { InMemoryBookRepository.new }
    let(:loan_repo) { InMemoryLoanRepository.new }
    let(:copy_repo) { InMemoryCopyRepository.new }
    let(:fine_repo) { InMemoryFineRepository.new }
    let(:reservation_repo) { InMemoryReservationRepository.new }
    let(:clock) { FixedClock.new(Date.new(2026, 9, 10)) }
    
    let(:service) do
      LoanService.new(
        member_repository: member_repo,
        book_repository: book_repo,
        loan_repository: loan_repo,
        copy_repository: copy_repo,
        reservation_repository: reservation_repo,
        borrowing_eligibility_policy: DefaultBorrowingEligibilityPolicy.new(fine_repo),
        clock: clock
      )
    end

    it "creates a loan and marks the copy as on loan" do
      member = Member.new(id: "member-1", email: "alice@example.com", tier: StandardTier.new)
      member_repo.save(member)

      book = Book.new(isbn: "isbn-dune", title: "Dune")
      book_repo.save(book)    

      copy = Copy.new(id: 1, isbn: "isbn-dune")
      copy_repo.save(copy)

      loan = service.borrow(member_id: "member-1", isbn: "isbn-dune")

      expect(loan.member_id).to eq("member-1")
      expect(loan.copy_id).to eq(1)
      expect(loan.due_date).to eq(Date.new(2026, 9, 24))
      expect(copy_repo.find(1).status).to eq(:on_loan)
    end

    it "raises MemberNotFoundError when the member does not exist" do
      expect {
        service.borrow(member_id: "member-1", isbn: "isbn-dune")
      }.to raise_error(MemberNotFoundError)
    end

    it "raises BookNotFoundError when the book does not exist" do
      member = Member.new(id: "member-1", email: "alice@example.com", tier: StandardTier.new)
      member_repo.save(member)

      expect {
        service.borrow(member_id: "member-1", isbn: "isbn-dune")
      }.to raise_error(BookNotFoundError)
    end

    it "raises NoCopiesAvailableError when no copies are available" do
      member = Member.new(id: "member-1", email: "alice@example.com", tier: StandardTier.new)
      member_repo.save(member)

      book = Book.new(isbn: "isbn-dune", title: "Dune")
      book_repo.save(book)

      expect {
        service.borrow(member_id: "member-1", isbn: "isbn-dune")
      }.to raise_error(NoCopiesAvailableError)
    end

    it "raises LoanLimitExceededError when the member has reached their tier's loan limit" do
      member = Member.new(id: "member-1", email: "alice@example.com", tier: StandardTier.new)
      member_repo.save(member)

      3.times do |i|
        isbn = "isbn-#{i}"
        book_repo.save(Book.new(isbn: isbn, title: "Book #{i}"))
        copy = Copy.new(id: copy_repo.next_identity, isbn: isbn, status: :on_loan)
        copy_repo.save(copy)
        loan_repo.save(Loan.new(
          id: loan_repo.next_identity,
          copy_id: copy.id,
          member_id: "member-1",
          borrowed_on: Date.today,
          due_date: Date.today + 14
        ))
      end

      book_repo.save(Book.new(isbn: "isbn-4", title: "Book 4"))
      copy_repo.save(Copy.new(id: copy_repo.next_identity, isbn: "isbn-4"))

      expect {
        service.borrow(member_id: "member-1", isbn: "isbn-4")
      }.to raise_error(LoanLimitExceededError)
    end

    it "raises OutstandingFinesError when the member has unpaid fines" do
      member = Member.new(id: "member-1", email: "alice@example.com", tier: StandardTier.new)
      member_repo.save(member)

      book = Book.new(isbn: "isbn-dune", title: "Dune")
      book_repo.save(book)    

      copy = Copy.new(id: 1, isbn: "isbn-dune")
      copy_repo.save(copy)

      unpaid_fine = Fine.new(
        id: fine_repo.next_identity, 
        member_id: "member-1", 
        loan_id: 1,
        amount: Money.of(100, "TRY"), 
        paid: false)
      fine_repo.save(unpaid_fine)

      expect {
        service.borrow(member_id: "member-1", isbn: "isbn-dune")
      }.to raise_error(OutstandingFinesError)
    end
  end

  describe "#reserve" do
    let(:member_repo) { InMemoryMemberRepository.new }
    let(:book_repo) { InMemoryBookRepository.new }
    let(:loan_repo) { InMemoryLoanRepository.new }
    let(:copy_repo) { InMemoryCopyRepository.new }
    let(:fine_repo) { InMemoryFineRepository.new }
    let(:reservation_repo) { InMemoryReservationRepository.new }
    let(:clock) { FixedClock.new(Date.new(2026, 9, 10)) }
    
    let(:service) do
      LoanService.new(
        member_repository: member_repo,
        book_repository: book_repo,
        loan_repository: loan_repo,
        copy_repository: copy_repo,
        reservation_repository: reservation_repo,
        borrowing_eligibility_policy: DefaultBorrowingEligibilityPolicy.new(fine_repo),
        clock: clock
      )
    end

    it "creates a pending reservation" do
      member = Member.new(
        id: "member-1", 
        email: "alice@example.com", 
        tier: StandardTier.new
      )
      member_repo.save(member)

      book = Book.new(isbn: "isbn-dune", title: "Dune")
      book_repo.save(book)    

      3.times do
        copy_repo.save(
          Copy.new(
            id: copy_repo.next_identity, 
            isbn: "isbn-dune", 
            status: :on_loan
          ))
      end

      reservation = service.reserve(member_id: "member-1", isbn: "isbn-dune")

      expect(reservation.status).to eq(:pending)
      expect(reservation.member_id).to eq("member-1")
      expect(reservation.isbn).to eq("isbn-dune")
    end

    it "raises BookNotFoundError when the book does not exist" do
      member = Member.new(
        id: "member-1", 
        email: "alice@example.com", 
        tier: StandardTier.new
      )
      member_repo.save(member)

      expect {
        service.reserve(member_id: "member-1", isbn: "isbn-nonexistent")
      }.to raise_error(BookNotFoundError)
    end

    it "raises CopyAvailableError when an available copy exists" do
      member = Member.new(
        id: "member-1", 
        email: "alice@example.com", 
        tier: StandardTier.new
      )
      member_repo.save(member)

      book = Book.new(isbn: "isbn-dune", title: "Dune")
      book_repo.save(book)    

      available_copy = Copy.new(id: copy_repo.next_identity, isbn: "isbn-dune")
      copy_repo.save(available_copy)

      expect {
        service.reserve(member_id: "member-1", isbn: "isbn-dune")
      }.to raise_error(CopyAvailableError)
    end

    it "raises AlreadyReservedError when the member already has an open reservation for the book" do
      member = Member.new(
        id: "member-1", 
        email: "alice@example.com", 
        tier: StandardTier.new
      )
      member_repo.save(member)

      book = Book.new(isbn: "isbn-dune", title: "Dune")
      book_repo.save(book)    

      on_loan_copy = Copy.new(
        id: copy_repo.next_identity, 
        isbn: "isbn-dune",
        status: :on_loan)
      copy_repo.save(on_loan_copy)

      reservation = Reservation.new(
        id: 1,
        isbn: "isbn-dune",
        member_id: "member-1",
        requested_at: Date.today
      )
      reservation_repo.save(reservation)

      expect {
        service.reserve(member_id: "member-1", isbn: "isbn-dune")
      }.to raise_error(AlreadyReservedError)
    end

    it "raises ReservationLimitExceededError when the member has reached their tier's reservation limit" do
      member = Member.new(id: "member-1", email: "alice@example.com", tier: StandardTier.new)
      member_repo.save(member)

      2.times do |i|
        isbn = "isbn-#{i}"
        book_repo.save(Book.new(isbn: isbn, title: "Book #{i}"))
        copy_repo.save(Copy.new(id: copy_repo.next_identity, isbn: isbn, status: :on_loan))
        service.reserve(member_id: "member-1", isbn: isbn)
      end

      book_repo.save(Book.new(isbn: "isbn-3", title: "Book 3"))
      copy_repo.save(Copy.new(id: copy_repo.next_identity, isbn: "isbn-3", status: :on_loan))

      expect {
        service.reserve(member_id: "member-1", isbn: "isbn-3")
      }.to raise_error(ReservationLimitExceededError)
    end
  end
end