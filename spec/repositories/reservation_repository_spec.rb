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

  describe "#find_fulfilled_for" do
    it "raises NotImplementedError" do
      expect {
        ReservationRepository.new.find_fulfilled_for(isbn: "isbn-dune", member_id: "member-1")
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
  ONE_DAY_IN_SECONDS = 24 * 60 * 60 
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

  describe "#queue_for" do
    it "returns pending reservations for the isbn, ordered by request date" do
      repo = InMemoryReservationRepository.new
      earlier_reservation = Reservation.new(
                              id: 1, 
                              isbn: "isbn-1984",
                              member_id: "member-1",
                              requested_at: Time.now - ONE_DAY_IN_SECONDS
                              )

      later_reservation = Reservation.new(
                            id: 2, 
                            isbn: "isbn-1984",
                            member_id: "member-2",
                            requested_at: Time.now
                            )

      repo.save(later_reservation)
      repo.save(earlier_reservation)

      result = repo.queue_for("isbn-1984")

      expect(result).to eq([earlier_reservation, later_reservation])
    end

    it "does not include fulfilled reservations" do
      repo = InMemoryReservationRepository.new
      earlier_reservation = Reservation.new(
                              id: 1, 
                              isbn: "isbn-1984",
                              member_id: "member-1",
                              requested_at: Time.now - ONE_DAY_IN_SECONDS
                            )

      later_reservation = Reservation.new(
                            id: 2, 
                            isbn: "isbn-1984",
                            member_id: "member-2",
                            requested_at: Time.now
                          )

      fulfilled_reservation = Reservation.new(
                                id: 3, 
                                isbn: "isbn-1984",
                                member_id: "member-3",
                                requested_at: Time.now,
                                status: :fulfilled
                              )           
                                   
      repo.save(later_reservation)
      repo.save(earlier_reservation)
      repo.save(fulfilled_reservation)

      result = repo.queue_for("isbn-1984")

      expect(result).to eq([earlier_reservation, later_reservation])
    end
  end

  describe "#find_fulfilled_for" do
    it "returns the fulfilled reservation for the given isbn and member" do
      repo = InMemoryReservationRepository.new
      fulfilled_reservation = Reservation.new(
                                id: 1,
                                isbn: "isbn-dune",
                                member_id: "member-1",
                                requested_at: Time.now,
                                status: :fulfilled
                              )

      repo.save(fulfilled_reservation)

      result = repo.find_fulfilled_for(isbn: "isbn-dune", member_id: "member-1")

      expect(result).to eq(fulfilled_reservation)
    end

    it "returns nil when the reservation is pending" do
      repo = InMemoryReservationRepository.new
      pending_reservation = Reservation.new(
                              id: 1,
                              isbn: "isbn-dune",
                              member_id: "member-1",
                              requested_at: Time.now
                            )

      repo.save(pending_reservation)

      result = repo.find_fulfilled_for(isbn: "isbn-dune", member_id: "member-1")

      expect(result).to be_nil
    end
  end

  describe "#active_count_for_member" do
    it "counts both pending and fulfilled reservations for the member" do
      repo = InMemoryReservationRepository.new
      member_1_pending_reservation = Reservation.new(id: 1, isbn: "isbn-dune", member_id: "member-1", requested_at: Time.now)
      member_1_fulfilled_reservation = Reservation.new(id: 2, isbn: "isbn-solo", member_id: "member-1", requested_at: Time.now, status: :fulfilled)
      member_2_reservation = Reservation.new(id: 3, isbn: "isbn-1984", member_id: "member-2", requested_at: Time.now)
      
      repo.save(member_1_pending_reservation)
      repo.save(member_1_fulfilled_reservation)
      repo.save(member_2_reservation)

      expect(repo.active_count_for_member("member-1")).to eq(2)
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