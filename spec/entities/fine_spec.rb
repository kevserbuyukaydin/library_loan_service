require_relative "../../lib/entities/fine"
require_relative "../../lib/value_objects/money"

RSpec.describe Fine do
  describe ".new" do
    it "creates a fine with the given attributes" do
      fine = Fine.new(
        id: 1,
        member_id: "member-1",
        loan_id: 1,
        amount: Money.of(100, "TRY")
      )

      expect(fine.id).to eq(1)
      expect(fine.member_id).to eq("member-1")
      expect(fine.loan_id).to eq(1)
      expect(fine.paid?).to be false
      expect(fine.amount.amount).to eq(100)
    end
  end

  describe "#mark_as_paid!" do
    it "changes paid status to true" do
      fine = Fine.new(
        id: 1,
        member_id: "member-1",
        loan_id: 1,
        amount: Money.of(100, "TRY")
      )

      fine.mark_as_paid!
      
      expect(fine.paid?).to be true
    end
  end
end