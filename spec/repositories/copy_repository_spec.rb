require_relative "../../lib/entities/copy"
require_relative "../../lib/repositories/copy_repository"

RSpec.describe CopyRepository do
  describe "#save" do
    it "raises NotImplementedError" do
      copy = Copy.new(id: 1, isbn: "isbn-dune")

      expect {
        CopyRepository.new.save(copy)
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#find" do
    it "raises NotImplementedError" do
      expect {
        CopyRepository.new.find(1)
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#copies_for_book" do
    it "raises NotImplementedError" do
      expect {
        CopyRepository.new.copies_for_book("isbn-dune")
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#available_copy_for" do
    it "raises NotImplementedError" do
      expect {
        CopyRepository.new.available_copy_for("isbn-dune")
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#held_copy_for" do
    it "raises NotImplementedError" do
      expect {
        CopyRepository.new.held_copy_for(isbn: "isbn-dune", member_id: "member-1")
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#held_copies_for" do
    it "raises NotImplementedError" do
      expect {
        CopyRepository.new.held_copies_for("isbn-dune")
      }.to raise_error(NotImplementedError)
    end
  end
end

RSpec.describe InMemoryCopyRepository do
  describe "#save and #find" do
    it "returns the saved copy by id" do
      repo = InMemoryCopyRepository.new
      copy = Copy.new(id: 1, isbn: "isbn-dune")

      repo.save(copy)

      expect(repo.find(1)).to eq(copy)
    end
  end

  describe "#find" do
    it "returns nil when the book is not found" do
      repo = InMemoryCopyRepository.new

      expect(repo.find("isbn-ghost")).to be_nil
    end
  end

  describe "#copies_for_book" do
    it "returns all copies for the given isbn" do
      repo = InMemoryCopyRepository.new
      dune_copy_1 = Copy.new(id: 1, isbn: "isbn-dune")
      dune_copy_2 = Copy.new(id: 2, isbn: "isbn-dune", status: :on_loan)
      solo_copy = Copy.new(id: 3, isbn: "isbn-solo")

      repo.save(dune_copy_1)
      repo.save(dune_copy_2)
      repo.save(solo_copy)

      result = repo.copies_for_book("isbn-dune")

      expect(result).to contain_exactly(dune_copy_1, dune_copy_2)
    end
  end

  describe "#available_copy_for" do
    it "return available copy for the given isbn" do
      repo = InMemoryCopyRepository.new
      dune_copy_1 = Copy.new(id: 1, isbn: "isbn-dune")
      dune_copy_2 = Copy.new(id: 2, isbn: "isbn-dune", status: :on_loan)

      repo.save(dune_copy_1)
      repo.save(dune_copy_2)

      result = repo.available_copy_for("isbn-dune")

      expect(result).to eq(dune_copy_1)
    end
  end

  describe "#held_copy_for" do
    it "returns the copy held for the given member" do
      repo = InMemoryCopyRepository.new
      dune_copy_1 = Copy.new(id: 1, isbn: "isbn-dune")
      dune_copy_2 = Copy.new(
                      id: 2, 
                      isbn: "isbn-dune", 
                      status: :held,
                      held_for_member_id: "member-1")

      repo.save(dune_copy_1)
      repo.save(dune_copy_2)

      result = repo.held_copy_for(isbn: "isbn-dune", member_id: "member-1")

      expect(result).to eq(dune_copy_2)
    end

    it "returns nil when the copy is held for a different member" do
      repo = InMemoryCopyRepository.new
      dune_copy = Copy.new(
                    id: 2,
                    isbn: "isbn-dune",
                    status: :held,
                    held_for_member_id: "member-1"
                  )

      repo.save(dune_copy)

      result = repo.held_copy_for(isbn: "isbn-dune", member_id: "member-2")

      expect(result).to be_nil
    end
  end

  describe "#held_copies_for" do
    it "returns held copies for the given isbn" do
      repo = InMemoryCopyRepository.new
      dune_copy_1 = Copy.new(id: 1, isbn: "isbn-dune")
      dune_copy_2 = Copy.new(
                      id: 2, 
                      isbn: "isbn-dune", 
                      status: :held,
                      held_for_member_id: "member-1")
      dune_copy_3 = Copy.new(
                      id: 3, 
                      isbn: "isbn-dune", 
                      status: :held,
                      held_for_member_id: "member-2")

      repo.save(dune_copy_1)
      repo.save(dune_copy_2)
      repo.save(dune_copy_3)

      result = repo.held_copies_for("isbn-dune")

      expect(result).to contain_exactly(dune_copy_2, dune_copy_3)
    end
  end

  describe "#next_identity" do
    it "returns increasing ids on each call" do
      repo = InMemoryCopyRepository.new

      first_id = repo.next_identity
      second_id = repo.next_identity

      expect(first_id).to eq(1)
      expect(second_id).to eq(2)
    end
  end
end