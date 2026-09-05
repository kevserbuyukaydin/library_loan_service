require_relative "../../lib/entities/member"
require_relative "../../lib/repositories/member_repository"
require_relative "../../lib/policies/membership_tier"

RSpec.describe MemberRepository do
  describe "#save" do
    it "raises NotImplementedError" do
      member = Member.new(
                  id: "member-1", 
                  email: "member-1@example.com",
                  tier: StandardTier.new
               )

      expect {
        MemberRepository.new.save(member)
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#find" do
    it "raises NotImplementedError" do
      expect {
        MemberRepository.new.find("member-1")
      }.to raise_error(NotImplementedError)
    end
  end
end

RSpec.describe InMemoryMemberRepository do
  describe "#save and #find" do
    it "returns the saved member by id" do
      repo = InMemoryMemberRepository.new
      member = Member.new(
                  id: "member-1", 
                  email: "member-1@example.com",
                  tier: StandardTier.new
               )

      repo.save(member)

      expect(repo.find("member-1")).to eq(member)
    end
  end

  describe "#find" do
    it "returns nil when the member is not found" do
      repo = InMemoryMemberRepository.new

      expect(repo.find("member-2")).to be_nil
    end
  end
end