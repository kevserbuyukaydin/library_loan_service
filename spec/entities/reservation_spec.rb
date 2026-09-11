require_relative "../../lib/entities/reservation"

RSpec.describe Reservation do
  describe ".new" do
    it "creates a reservation with the given attributes" do
      requested_at = Time.now

      reservation = Reservation.new(
              id: 1,
              isbn: "isbn-dune",
              member_id: "member-1",
              requested_at: requested_at
      )

      expect(reservation.id).to eq(1)
      expect(reservation.isbn).to eq("isbn-dune")
      expect(reservation.member_id).to eq("member-1")
      expect(reservation.requested_at).to eq(requested_at)
      expect(reservation.pending?).to be true
    end
  end
  
    
  describe "#pending?" do
    it "returns true when status is pending" do
      requested_at = Time.now

      reservation = Reservation.new(
              id: 1,
              isbn: "isbn-dune",
              member_id: "member-1",
              requested_at: requested_at
      )
      
      expect(reservation.pending?).to be true
    end

    it "returns false when status is awaiting_pickup" do
      requested_at = Time.now

      reservation = Reservation.new(
              id: 1,
              isbn: "isbn-dune",
              member_id: "member-1",
              requested_at: requested_at,
              status: :awaiting_pickup
      )
      
      expect(reservation.pending?).to be false
    end
  end

  describe "#awaiting_pickup?" do
    it "returns true when status is awaiting_pickup" do
      requested_at = Time.now

      reservation = Reservation.new(
              id: 1,
              isbn: "isbn-dune",
              member_id: "member-1",
              requested_at: requested_at,
              status: :awaiting_pickup
      )
      
      expect(reservation.awaiting_pickup?).to be true
    end

    it "returns false when status is pending" do
      requested_at = Time.now

      reservation = Reservation.new(
              id: 1,
              isbn: "isbn-dune",
              member_id: "member-1",
              requested_at: requested_at
      )
      
      expect(reservation.awaiting_pickup?).to be false
    end
  end



  describe "#mark_as_awaiting_pickup!" do
    it "changes status to awaiting_pickup" do
      requested_at = Time.now

      reservation = Reservation.new(
              id: 1,
              isbn: "isbn-dune",
              member_id: "member-1",
              requested_at: requested_at
      )

      reservation.mark_as_awaiting_pickup!

      expect(reservation.awaiting_pickup?).to be true
    end
  end
end