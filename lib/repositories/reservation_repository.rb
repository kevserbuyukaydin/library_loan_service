class ReservationRepository
  def save(reservation)
    raise NotImplementedError
  end

  def find(id)
    raise NotImplementedError
  end

  def remove(id)
    raise NotImplementedError
  end

  def queue_for(isbn)
    raise NotImplementedError
  end

  def find_awaiting_pickup_for(isbn:, member_id:)
    raise NotImplementedError
  end

  def open_count_for_member(member_id)
    raise NotImplementedError
  end

  def next_identity
    raise NotImplementedError
  end
end

class InMemoryReservationRepository < ReservationRepository
  def initialize
    @reservations = {}
    @next_id = 1
  end

  def save(reservation)
    @reservations[reservation.id] = reservation
  end

  def find(id)
    @reservations[id]
  end

  def remove(id)
    @reservations.delete(id)
  end

  def queue_for(isbn)
    @reservations.values
      .select { |reservation| reservation.isbn == isbn && reservation.pending? } 
      .sort_by(&:requested_at)
  end

  def find_awaiting_pickup_for(isbn:, member_id:)
    @reservations.values.find do |reservation|
      reservation.isbn == isbn && reservation.member_id == member_id && reservation.awaiting_pickup?
    end
  end

  def open_count_for_member(member_id)
    @reservations.values.count do |reservation|
      reservation.member_id == member_id && reservation.open?
    end
  end

  def next_identity
    id = @next_id
    @next_id += 1
    id
  end
end