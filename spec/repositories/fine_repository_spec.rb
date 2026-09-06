require_relative "../../lib/entities/fine"
require_relative "../../lib/repositories/fine_repository"
require_relative "../../lib/value_objects/money"

RSpec.describe FineRepository do
  describe "#save" do
    it "raises NotImplementedError" do
      fine = Fine.new(id: 1, member_id: "member-1", loan_id: 1, amount: Money.of(100, "TRY"))

      expect {
        FineRepository.new.save(fine)
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#find" do
    it "raises NotImplementedError" do
      expect {
        FineRepository.new.find(1)
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#unpaid_fines_for" do
    it "raises NotImplementedError" do
      expect {
        FineRepository.new.unpaid_fines_for("member-1")
      }.to raise_error(NotImplementedError)
    end
  end
end

RSpec.describe InMemoryFineRepository do
  describe "#save and #find" do
    it "returns the saved fine by id" do
      repo = InMemoryFineRepository.new
      fine = Fine.new(id: 1, member_id: "member-1", loan_id: 1, amount: Money.of(100, "TRY"))

      repo.save(fine)

      expect(repo.find(1)).to eq(fine)
    end
  end

  describe "#find" do
    it "returns nil when the fine is not found" do
      repo = InMemoryFineRepository.new

      expect(repo.find(1)).to be_nil
    end
  end

  describe "#unpaid_fines_for" do
    it "returns all unpaid fines for the given member id" do
      repo = InMemoryFineRepository.new
      member_1_paid_fine = Fine.new(id: 1, member_id: "member-1", loan_id: 1, amount: Money.of(100, "TRY"), paid: true)
      member_1_unpaid_fine = Fine.new(id: 2, member_id: "member-1", loan_id: 2, amount: Money.of(100, "TRY"))
      member_2_unpaid_fine = Fine.new(id: 3, member_id: "member-2", loan_id: 3, amount: Money.of(100, "TRY"))

      repo.save(member_1_paid_fine)
      repo.save(member_1_unpaid_fine)
      repo.save(member_2_unpaid_fine)

      result = repo.unpaid_fines_for("member-1")

      expect(result).to contain_exactly(member_1_unpaid_fine)
    end
  end

  describe "#next_identity" do
    it "returns increasing ids on each call" do
      repo = InMemoryFineRepository.new

      first_id = repo.next_identity
      second_id = repo.next_identity

      expect(first_id).to eq(1)
      expect(second_id).to eq(2)
    end
  end
end