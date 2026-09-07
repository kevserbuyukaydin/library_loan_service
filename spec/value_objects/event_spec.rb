require_relative "../../lib/value_objects/event"

RSpec.describe Event do
  describe ".new" do
    it "creates an event with the given attributes" do
      event = Event.new(
        action: "borrow",
        member_id: "member-1",
        occurred_at: Time.now,
        details: { copy_id: 1, 
                   book_isbn: "isbn-dune" 
                 }
      )

      expect(event.action).to eq("borrow")
      expect(event.member_id).to eq("member-1")
      expect(event.occurred_at).to be_an_instance_of(Time)
      expect(event.details).to eq({ copy_id: 1, book_isbn: "isbn-dune" })
    end

    it "defaults details to an empty hash when not given" do
      event = Event.new(
        action: "borrow",
        member_id: "member-1",
        occurred_at: Time.now
      )

      expect(event.details).to eq({})
    end
  end
end