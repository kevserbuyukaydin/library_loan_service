require_relative "../../lib/entities/member"
require_relative "../../lib/policies/membership_tier"

RSpec.describe Member do
  describe ".new" do
    it "creates a member with id, email, and tier" do
      member = Member.new(
        id: "m1", 
        email: "john@example.com", 
        tier: StandardTier.new
      )
      
      expect(member.id).to eq("m1")
      expect(member.email).to eq("john@example.com")
      expect(member.tier.max_loans).to eq(3)
    end
  end
end