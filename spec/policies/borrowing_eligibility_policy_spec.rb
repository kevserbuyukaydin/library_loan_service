require_relative "../../lib/policies/borrowing_eligibility_policy"
require_relative "../../lib/repositories/fine_repository"
require_relative "../../lib/entities/fine"
require_relative "../../lib/value_objects/money"

RSpec.describe BorrowingEligibilityPolicy do
  describe "#eligible?" do
    it "raises NotImplementedError" do
      expect {
        BorrowingEligibilityPolicy.new.eligible?("member-1")
      }.to raise_error(NotImplementedError)
    end
  end
end

RSpec.describe DefaultBorrowingEligibilityPolicy do
  describe "#eligible?" do
    it "returns false when the member has an unpaid fine" do
      repo = InMemoryFineRepository.new
      member_1_unpaid_fine = Fine.new(
        id: 2, 
        member_id: "member-1", 
        loan_id: 2, 
        amount: Money.of(100, "TRY")
      )

      repo.save(member_1_unpaid_fine)
      policy = DefaultBorrowingEligibilityPolicy.new(repo)

      expect(policy.eligible?("member-1")).to eq(false)
    end

    it "returns true when the member has no unpaid fines" do
      repo = InMemoryFineRepository.new
      member_1_paid_fine = Fine.new(
        id: 1, 
        member_id: "member-1", 
        loan_id: 1, 
        amount: Money.of(100, "TRY"), 
        paid: true
      )

      repo.save(member_1_paid_fine)
      policy = DefaultBorrowingEligibilityPolicy.new(repo)

      expect(policy.eligible?("member-1")).to eq(true)
    end
  end
end