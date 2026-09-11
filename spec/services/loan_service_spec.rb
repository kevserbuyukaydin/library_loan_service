require_relative "../../lib/services/loan_service"
require_relative "../../lib/repositories/member_repository"
require_relative "../../lib/repositories/book_repository"
require_relative "../../lib/repositories/copy_repository"
require_relative "../../lib/repositories/loan_repository"
require_relative "../../lib/entities/member"
require_relative "../../lib/entities/book"
require_relative "../../lib/entities/copy"
require_relative "../../lib/policies/membership_tier"
require_relative "../../lib/ports/clock"
require_relative "../../lib/errors"

RSpec.describe LoanService do
  describe "#borrow" do
    it "creates a loan and marks the copy as on loan" do
      member_repo = InMemoryMemberRepository.new
      book_repo = InMemoryBookRepository.new
      loan_repo = InMemoryLoanRepository.new
      copy_repo = InMemoryCopyRepository.new
      clock = FixedClock.new(Date.new(2026, 9, 10))

      service = LoanService.new(
        member_repository: member_repo,
        book_repository: book_repo,
        loan_repository: loan_repo,
        copy_repository: copy_repo,
        clock: clock
      )

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
  end
end