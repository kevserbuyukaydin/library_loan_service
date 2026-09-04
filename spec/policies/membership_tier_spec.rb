require_relative "../../lib/policies/membership_tier"

RSpec.describe MembershipTier do
  describe "#loan_period_days" do
    it "raises NotImplementedError" do
      expect {
        MembershipTier.new.loan_period_days
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#max_loans" do
    it "raises NotImplementedError" do
      expect {
        MembershipTier.new.max_loans
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#max_renewals" do
    it "raises NotImplementedError" do
      expect {
        MembershipTier.new.max_renewals
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#max_reservations" do
    it "raises NotImplementedError" do
      expect {
        MembershipTier.new.max_reservations
      }.to raise_error(NotImplementedError)
    end
  end
end

RSpec.describe StandardTier do
  subject(:tier) { StandardTier.new }

  describe "#loan_period_days" do
    it "returns 14 days" do
      expect(tier.loan_period_days).to eq(14)
    end
  end

  describe "#max_loans" do
    it "returns 3" do
      expect(tier.max_loans).to eq(3)
    end
  end

  describe "#max_renewals" do
    it "returns 1" do
      expect(tier.max_renewals).to eq(1)
    end
  end

  describe "#max_reservations" do
    it "returns 2" do
      expect(tier.max_reservations).to eq(2)
    end
  end
end


RSpec.describe PremiumTier do
  subject(:tier) { PremiumTier.new }

  describe "#loan_period_days" do
    it "returns 30 days" do
      expect(tier.loan_period_days).to eq(30)
    end
  end

  describe "#max_loans" do
    it "returns 5" do
      expect(tier.max_loans).to eq(5)
    end
  end

  describe "#max_renewals" do
    it "returns 3" do
      expect(tier.max_renewals).to eq(3)
    end
  end

  describe "#max_reservations" do
    it "returns 4" do
      expect(tier.max_reservations).to eq(4)
    end
  end
end