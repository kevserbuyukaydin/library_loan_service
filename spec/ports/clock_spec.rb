require_relative "../../lib/ports/clock"

RSpec.describe Clock do
  describe "#today" do
    it "raises NotImplementedError" do
      expect {
        Clock.new.today
      }.to raise_error(NotImplementedError)
    end
  end
end

RSpec.describe SystemClock do
  describe "#today" do
    it "return today's date" do
      expect(SystemClock.new.today).to eq(Date.today)
    end
  end
end

RSpec.describe FixedClock do
    describe "#today" do
    it "returns the date it was initialized with" do
      fixed_date = Date.new(2026, 8, 1)
      fixed_clock = FixedClock.new(fixed_date)

      expect(fixed_clock.today).to eq(fixed_date)
    end
  end
end