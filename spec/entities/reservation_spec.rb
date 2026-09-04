require_relative "../../lib/entities/reservation"

RSpec.describe Reservation do
  describe ".new" do
    it "creates a reservation with the given attributes" do
      requested_on = Date.today

      reservation = Reservation.new(
              id: 1,
              isbn: "isbn-dune",
              member_id: "m1",
              requested_on: requested_on
      )

      expect(reservation.id).to eq(1)
      expect(reservation.isbn).to eq("isbn-dune")
      expect(reservation.member_id).to eq("m1")
      expect(reservation.requested_on).to eq(requested_on)
    end
  end
end