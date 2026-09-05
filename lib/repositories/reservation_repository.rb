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

  def active_count_for_member(member_id)
    raise NotImplementedError
  end
  
  def next_identity
    raise NotImplementedError
  end
end

