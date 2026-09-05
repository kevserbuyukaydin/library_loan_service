require_relative "../../lib/entities/reservation"
require_relative "../../lib/repositories/reservation_repository"

RSpec.describe ReservationRepository do
  describe "#save" do
    it "raises NotImplementedError" do
      reservation = Reservation.new(
                      id: 1, 
                      isbn: "isbn-dune",
                      member_id: "member-1",
                      requested_at: Time.now)

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

RSpec.describe InMemoryReservationRepository do
  describe "#save and #find" do
    it "returns the saved reservation by id" do
      repo = InMemoryReservationRepository.new
      reservation = Reservation.new(
                      id: 1, 
                      isbn: "isbn-dune",
                      member_id: "member-1",
                      requested_at: Time.now)

      repo.save(reservation)

      expect(repo.find(1)).to eq(reservation)
    end
  end

  describe "#remove" do
    it "removes the reservation so it can no longer be found" do
      repo = InMemoryReservationRepository.new
      reservation = Reservation.new(
                      id: 1, 
                      isbn: "isbn-dune",
                      member_id: "member-1",
                      requested_at: Time.now)

      repo.save(reservation)
      repo.remove(reservation.id)

      expect(repo.find(1)).to be_nil
    end
  end

  describe "#next_identity" do
    it "returns increasing ids on each call" do
      repo = InMemoryReservationRepository.new

      first_id = repo.next_identity
      second_id = repo.next_identity

      expect(first_id).to eq(1)
      expect(second_id).to eq(2)
    end
  end
end