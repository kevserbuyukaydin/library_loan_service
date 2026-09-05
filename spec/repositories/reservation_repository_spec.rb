require_relative "../../lib/entities/reservation"
require_relative "../../lib/repositories/reservation_repository"

RSpec.describe ReservationRepository do
  describe "#save" do
    it "raises NotImplementedError" do
      reservation = Reservation.new(
                      id: 1, 
                      isbn: "isbn-dune",
                      member_id: "member-1",
                      requested_on: Date.new(2026, 9, 1))

      expect {
        ReservationRepository.new.save(reservation)
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#find" do
    it "raises NotImplementedError" do
      expect {
        ReservationRepository.new.find(1)
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#remove" do
    it "raises NotImplementedError" do
      expect {
        ReservationRepository.new.remove(1)
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#queue_for" do
    it "raises NotImplementedError" do
      expect {
        ReservationRepository.new.queue_for("isbn-dune")
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#active_count_for_member" do
    it "raises NotImplementedError" do
      expect {
        ReservationRepository.new.active_count_for_member("member-1")
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#next_identity" do
    it "raises NotImplementedError" do
      expect {
        ReservationRepository.new.next_identity
      }.to raise_error(NotImplementedError)
    end
  end
end