require_relative "../../lib/ports/notifier"
require_relative "../../lib/entities/copy"

RSpec.describe Notifier do
  describe "#notify" do
    it "raises NotImplementedError" do
      expect {
        Notifier.new.notify("member-1", nil)
      }.to raise_error(NotImplementedError)
    end
  end
end

RSpec.describe InMemoryNotifier do
  describe "#notify" do
    it "records a notification for the member" do
      notifier = InMemoryNotifier.new 
      copy = Copy.new(
        id: 1, isbn: "isbn-dune", 
        status: :held, 
        held_at: Date.today)

      notifier.notify("member-1", copy) 

      expect(notifier.notifications_for("member-1").size).to eq(1) 
    end
  end

  describe "#notifications_for" do
    it "does not include notifications for other members" do
      notifier = InMemoryNotifier.new 
      copy = Copy.new(
        id: 1, isbn: "isbn-dune", 
        status: :held, 
        held_at: Date.today)

      notifier.notify("member-1", copy)

      expect(notifier.notifications_for("member-2").size).to eq(0) 
    end
  end
end
