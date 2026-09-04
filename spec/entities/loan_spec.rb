require_relative "../../lib/entities/loan"

RSpec.describe Loan do
  describe ".new" do
    it "creates a loan with the given attributes" do
      borrowed_on = Date.today
      due_date = borrowed_on + 14

      loan = Loan.new(
        id: 1,
        copy_id: 1,
        member_id: "m1",
        borrowed_on: borrowed_on,
        due_date: due_date
      )

      expect(loan.id).to eq(1)
      expect(loan.copy_id).to eq(1)
      expect(loan.member_id).to eq("m1")
      expect(loan.borrowed_on).to eq(borrowed_on)
      expect(loan.due_date).to eq(due_date)
    end
  end

  describe "#overdue?" do
    it "returns false when due_date has not passed" do
      due_date = Date.today + 14

      loan = Loan.new(
        id: 1,
        copy_id: 1,
        member_id: "m1",
        borrowed_on: Date.today,
        due_date: due_date
      )

      expect(loan.overdue?(Date.today)).to be false
    end

    it "returns false when today is exactly the due_date" do
      due_date = Date.today

      loan = Loan.new(
        id: 1,
        copy_id: 1,
        member_id: "m1",
        borrowed_on: Date.today - 14,
        due_date: due_date
      )

      expect(loan.overdue?(Date.today)).to be false
    end

    it "returns true when due_date has passed" do
      due_date = Date.today - 1

      loan = Loan.new(
        id: 1,
        copy_id: 1,
        member_id: "m1",
        borrowed_on: Date.today - 15,
        due_date: due_date
      )

      expect(loan.overdue?(Date.today)).to be true
    end
  end
end