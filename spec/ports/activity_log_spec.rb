require_relative "../../lib/ports/activity_log"
require_relative "../../lib/value_objects/event"

RSpec.describe ActivityLog do
  describe "#record" do
    it "raises NotImplementedError" do
      expect {
        ActivityLog.new.record(nil)
      }.to raise_error(NotImplementedError)
    end
  end
end

RSpec.describe InMemoryActivityLog do
  describe "#record and #events" do
    it "stores recorded events" do
      log = InMemoryActivityLog.new
      event1 = Event.new(
        action: "borrow", 
        member_id: "member-1", 
        occurred_at: Time.now,
        details: { copy_id: 1, book_isbn: "isbn-dune" }
      )
      event2 = Event.new(
        action: "return",
        member_id: "member-2",
        occurred_at: Time.now,
        details: { copy_id: 2, book_isbn: "isbn-dune" }
      )

      log.record(event1)
      log.record(event2)

      expect(log.events).to contain_exactly(event1, event2)
    end
  end
end