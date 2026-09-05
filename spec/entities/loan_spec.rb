require_relative "../../lib/entities/loan"

RSpec.describe Loan do
  describe ".new" do
    it "creates a loan with the given attributes" do
      borrowed_on = Date.today
      due_date = borrowed_on + 14

      loan = Loan.new(
        id: 1,
        copy_id: 1,
        member_id: "member-1",
        borrowed_on: borrowed_on,
        due_date: due_date,
        returned_at: nil,
        status: :active
      )

      expect(loan.id).to eq(1)
      expect(loan.copy_id).to eq(1)
      expect(loan.member_id).to eq("member-1")
      expect(loan.borrowed_on).to eq(borrowed_on)
      expect(loan.due_date).to eq(due_date)
      expect(loan.returned_at).to be_nil
      expect(loan.status).to eq(:active)
    end
  end

  describe "#active?" do
    it "returns true when status is active" do
      borrowed_on = Date.today
      due_date = borrowed_on + 14

      loan = Loan.new(
        id: 1,
        copy_id: 1,
        member_id: "member-1",
        borrowed_on: borrowed_on,
        due_date: due_date,
        returned_at: nil,
        status: :active
      )

      expect(loan.active?).to be true
    end

    it "returns false when status is not active" do
      borrowed_on = Date.today
      due_date = borrowed_on + 14
      returned_at = due_date + 5

      loan = Loan.new(
        id: 1,
        copy_id: 1,
        member_id: "member-1",
        borrowed_on: borrowed_on,
        due_date: due_date,
        returned_at: returned_at,
        status: :returned
      )
      
      expect(loan.active?).to be false
    end
  end

  describe "#returned?" do
    it "returns true when status is returned" do
      borrowed_on = Date.today
      due_date = borrowed_on + 14
      returned_at = due_date

      loan = Loan.new(
        id: 1,
        copy_id: 1,
        member_id: "member-1",
        borrowed_on: borrowed_on,
        due_date: due_date,
        returned_at: returned_at,
        status: :returned
      )

      expect(loan.returned?).to be true
    end

    it "returns false when status is not returned" do
      borrowed_on = Date.today
      due_date = borrowed_on + 14

      loan = Loan.new(
        id: 1,
        copy_id: 1,
        member_id: "member-1",
        borrowed_on: borrowed_on,
        due_date: due_date,
        returned_at: nil,
        status: :active
      )

      expect(loan.returned?).to be false
    end
  end

  describe "#return!" do
    it "changes status to returned and sets returned_at" do
      borrowed_on = Date.today
      due_date = borrowed_on + 14
      returned_at = due_date + 5 

      loan = Loan.new(
        id: 1,
        copy_id: 1,
        member_id: "member-1",
        borrowed_on: borrowed_on,
        due_date: due_date,
        returned_at: nil,
        status: :active
      )

      loan.return!(on: returned_at)

      expect(loan.status).to eq(:returned)
      expect(loan.returned_at).to eq(returned_at)
    end
  end

  describe "#overdue?" do
    it "returns false when due_date has not passed" do
      due_date = Date.today + 14

      loan = Loan.new(
        id: 1,
        copy_id: 1,
        member_id: "member-1",
        borrowed_on: Date.today,
        due_date: due_date,
        status: :active,
        returned_at: nil
      )

      expect(loan.overdue?(Date.today)).to be false
    end

    it "returns false when today is exactly the due_date" do
      due_date = Date.today

      loan = Loan.new(
        id: 1,
        copy_id: 1,
        member_id: "member-1",
        borrowed_on: Date.today - 14,
        due_date: due_date,
        status: :active,
        returned_at: nil
      )

      expect(loan.overdue?(Date.today)).to be false
    end

    it "returns true when due_date has passed" do
      due_date = Date.today - 1

      loan = Loan.new(
        id: 1,
        copy_id: 1,
        member_id: "member-1",
        borrowed_on: Date.today - 15,
        due_date: due_date
      )

      expect(loan.overdue?(Date.today)).to be true
    end

    it "returns true for a returned loan if it was overdue" do
      borrowed_on = Date.today
      due_date = borrowed_on + 14
      returned_at = due_date + 5

      loan = Loan.new(
        id: 1,
        copy_id: 1,
        member_id: "member-1",
        borrowed_on: borrowed_on,
        due_date: due_date,
        returned_at: returned_at,
        status: :returned
      )

      expect(loan.overdue?(returned_at)).to be true
    end
  end
end