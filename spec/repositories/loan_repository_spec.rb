require_relative "../../lib/entities/loan"
require_relative "../../lib/repositories/loan_repository"

RSpec.describe LoanRepository do
  describe "#save" do
    it "raises NotImplementedError" do
      loan = Loan.new(
                id: 1, 
                copy_id: 1, 
                member_id: "member-1", 
                borrowed_on: Date.today, 
                due_date: Date.today + 14
             )

      expect {
        LoanRepository.new.save(loan)
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#find" do
    it "raises NotImplementedError" do
      expect {
        LoanRepository.new.find(1)
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#remove" do
    it "raises NotImplementedError" do
      expect {
        LoanRepository.new.remove(1)
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#active_loans_for_member" do
    it "raises NotImplementedError" do
      expect {
        LoanRepository.new.active_loans_for_member("member-1")
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#find_active_loan_for_copy" do
    it "raises NotImplementedError" do
      expect {
        LoanRepository.new.find_active_loan_for_copy(1)
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#next_identity" do
    it "raises NotImplementedError" do
      expect {
        LoanRepository.new.next_identity
      }.to raise_error(NotImplementedError)
    end
  end
end

RSpec.describe InMemoryLoanRepository do
  describe "#save and #find" do
    it "returns the saved loan by id" do
      repo = InMemoryLoanRepository.new
      loan = Loan.new(
              id: 1, 
              copy_id: 1, 
              member_id: "member-1",                 
              borrowed_on: Date.today, 
              due_date: Date.today + 14
             )

      repo.save(loan)

      expect(repo.find(1)).to eq(loan)
    end
  end

  describe "#remove" do
    it "removes the loan so it can no longer be found" do
      repo = InMemoryLoanRepository.new
      loan = Loan.new(
              id: 1, 
              copy_id: 1, 
              member_id: "member-1",                 
              borrowed_on: Date.today, 
              due_date: Date.today + 14
             )

      repo.save(loan)
      repo.remove(1)

      expect(repo.find(1)).to be_nil
    end
  end

  describe "#active_loans_for_member" do
    it "returns all loans for the given member" do
      repo = InMemoryLoanRepository.new
      member_1_loan_1 = Loan.new(id: 1, copy_id: 1, member_id: "member-1", borrowed_on: Date.today, due_date: Date.today + 14)
      member_1_loan_2 = Loan.new(id: 2, copy_id: 2, member_id: "member-1", borrowed_on: Date.today, due_date: Date.today + 14)
      member_2_loan = Loan.new(id: 3, copy_id: 3, member_id: "member-2", borrowed_on: Date.today, due_date: Date.today + 14)

      repo.save(member_1_loan_1)
      repo.save(member_1_loan_2)
      repo.save(member_2_loan)

      result = repo.active_loans_for_member("member-1")

      expect(result).to contain_exactly(member_1_loan_1, member_1_loan_2)
    end
  end

  describe "#find_active_loan_for_copy" do
    it "returns the active loan for the given copy" do
      repo = InMemoryLoanRepository.new
      member_1_loan_1 = Loan.new(id: 1, copy_id: 1, member_id: "member-1", borrowed_on: Date.today, due_date: Date.today + 14)
      member_1_loan_2 = Loan.new(id: 2, copy_id: 2, member_id: "member-1", borrowed_on: Date.today, due_date: Date.today + 14)
      member_2_loan = Loan.new(id: 3, copy_id: 3, member_id: "member-2", borrowed_on: Date.today, due_date: Date.today + 14)

      repo.save(member_1_loan_1)
      repo.save(member_1_loan_2)
      repo.save(member_2_loan)

      result = repo.find_active_loan_for_copy(3)

      expect(result).to eq(member_2_loan)
    end
  end

  describe "#next_identity" do
    it "returns increasing ids on each call" do
      repo = InMemoryLoanRepository.new

      first_id = repo.next_identity
      second_id = repo.next_identity

      expect(first_id).to eq(1)
      expect(second_id).to eq(2)
    end
  end
end