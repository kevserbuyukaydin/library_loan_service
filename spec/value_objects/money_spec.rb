require_relative "../../lib/value_objects/money"

RSpec.describe Money do
  describe ".new" do
    it "does not allow direct instantiation via new" do
      expect { Money.new(10, "TRY") }.to raise_error(NoMethodError)
    end

    it "is private" do
      expect(Money.private_methods).to include(:new)
    end

    it "keeps validate private" do
      expect(Money.private_methods).to include(:validate)
    end
  end

  describe ".of" do
    it "creates a valid Money instance" do
      money = Money.of(10, "TRY")

      expect(money.amount).to eq(10)
      expect(money.currency).to eq("TRY")
    end

    it "raises an error when amount is negative" do
      expect { Money.of(-10, "TRY") }.to raise_error(Money::InvalidMoneyError, "Amount cannot be negative")
    end
  end

  describe "#+" do
    it "adds two Money objects" do
      money1 = Money.of(10, "TRY")
      money2 = Money.of(20, "TRY")

      result = money1 + money2

      expect(result.amount).to eq(30)
      expect(result.currency).to eq("TRY")
    end
  end

  describe "#*" do
    it "multiplies the amount" do
      money = Money.of(10, "TRY")

      result = money * 3

      expect(result.amount).to eq(30)
      expect(result.currency).to eq("TRY")
    end
  end

  describe "#zero?" do
    it "returns true when amount is zero" do
      money = Money.of(0, "TRY")

      expect(money.zero?).to be true
    end

    it "returns false when amount is not zero" do
      money = Money.of(10, "TRY")

      expect(money.zero?).to be false
    end
  end
end