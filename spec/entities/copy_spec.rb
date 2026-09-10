require_relative "../../lib/entities/copy"

RSpec.describe Copy do
  describe "initial state" do
    it "is available by default" do
      copy = Copy.new(id: 1, isbn: "isbn-dune")

      expect(copy.status).to eq(:available)
      expect(copy.held_at).to be_nil
    end
  end

  describe "#available?" do
    it "returns true when status is available" do
      copy = Copy.new(id: 1, isbn: "isbn-dune")

      expect(copy.available?).to be true
    end

    it "returns false when status is not available" do
      copy = Copy.new(id: 1, isbn: "isbn-dune", status: :on_loan)
      
      expect(copy.available?).to be false
    end
  end

  describe "#on_loan?" do
    it "returns true when status is on_loan" do
      copy = Copy.new(id: 1, isbn: "isbn-dune", status: :on_loan)

      expect(copy.on_loan?).to be true
    end

    it "returns false when status is not on_loan" do
      copy = Copy.new(id: 1, isbn: "isbn-dune")
      
      expect(copy.on_loan?).to be false
    end
  end

  describe "#held?" do
    it "returns true when status is held" do
      copy = Copy.new(id: 1, isbn: "isbn-dune", status: :held, held_at: Date.today)

      expect(copy.held?).to be true
    end

    it "returns false when status is not held" do
      copy = Copy.new(id: 1, isbn: "isbn-dune")
      
      expect(copy.held?).to be false
    end
  end

  describe "#withdrawn?" do
    it "returns true when status is withdrawn" do
      copy = Copy.new(id: 1, isbn: "isbn-dune", status: :withdrawn, withdrawn_at: Date.today)

      expect(copy.withdrawn?).to be true
    end

    it "returns false when status is not withdrawn" do
      copy = Copy.new(id: 1, isbn: "isbn-dune")

      expect(copy.withdrawn?).to be false
    end
  end

  describe "state transitions" do
    it "moves to on_loan when loaned" do
      copy = Copy.new(id: 1, isbn: "isbn-dune", status: :held, held_at: Date.today)

      copy.loan!

      expect(copy.status).to eq(:on_loan)
      expect(copy.held_at).to be_nil
    end

    it "moves to available when returned" do
      copy = Copy.new(id: 1, isbn: "isbn-dune", status: :held, held_at: Date.today)

      copy.return!

      expect(copy.status).to eq(:available)
      expect(copy.held_at).to be_nil
    end

    it "moves to held and sets held_at and held_for_member_id when held" do
     copy = Copy.new(id: 1, isbn: "isbn-dune")
     today = Date.today

     copy.hold!(on: today, member_id: "member-1")

     expect(copy.status).to eq(:held)
     expect(copy.held_at).to eq(today)
     expect(copy.held_for_member_id).to eq("member-1")
    end

    it "moves to available and clears held_at when hold is released" do
      copy = Copy.new(
        id: 1, 
        isbn: "isbn-dune", 
        status: :held, 
        held_at: Date.today + 4,
        held_for_member_id: "member-1"
        )

      copy.release_hold!

      expect(copy.status).to eq(:available)
      expect(copy.held_at).to be_nil
      expect(copy.held_for_member_id).to be_nil
    end

    it "moves to withdrawn and sets withdrawn_at when withdrawn" do
      copy = Copy.new(id: 1, isbn: "isbn-dune")
      today = Date.today

      copy.withdraw!(on: today)

      expect(copy.status).to eq(:withdrawn)
      expect(copy.withdrawn_at).to eq(today)
    end
  end

  describe "#hold_expired?" do
    it "returns false when less than the expiry period has passed" do
      copy = Copy.new(id: 1, isbn: "isbn-dune", status: :held, held_at: Date.today - 1)

      expect(copy.hold_expired?(Date.today)).to be false
    end

    it "returns true when more than the expiry period has passed" do
      copy = Copy.new(id: 1, isbn: "isbn-dune", status: :held, held_at: Date.today - 4)

      expect(copy.hold_expired?(Date.today)).to be true
    end

    it "returns false when the copy is not held" do
      copy = Copy.new(id: 1, isbn: "isbn-dune", status: :available)

      expect(copy.hold_expired?(Date.today)).to be false
    end
  end
end