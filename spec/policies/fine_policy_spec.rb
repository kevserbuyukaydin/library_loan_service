require_relative "../../lib/policies/fine_policy"
require_relative "../../lib/entities/loan"

RSpec.describe FinePolicy do
  describe "#calculate" do
    it "raises NotImplementedError" do
      expect {
        FinePolicy.new.calculate(nil)
      }.to raise_error(NotImplementedError)
    end
  end
end

RSpec.describe DailyRateFinePolicy do
  describe "#calculate" do
    it "returns zero fine when returned on time" do
      loan = Loan.new(
        id: 1,
        copy_id: 1,
        member_id: "member-1",
        borrowed_on: Date.today - 20,
        due_date: Date.today - 6,
        returned_at: Date.today - 10,
        status: :returned
      )

      result = DailyRateFinePolicy.new.calculate(loan)

      expect(result.amount).to eq(0)
    end

    it "returns the daily rate multiplied by days late" do
      loan = Loan.new(
        id: 2,
        copy_id: 2,
        member_id: "member-1",
        borrowed_on: Date.today - 20,
        due_date: Date.today - 15,
        returned_at: Date.today - 5,
        status: :returned
      )

      result = DailyRateFinePolicy.new.calculate(loan)

      expect(result.amount).to eq(1000)
    end
  end
end