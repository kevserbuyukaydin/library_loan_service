class FineRepository
  def save(fine)
    raise NotImplementedError
  end

  def find(id)
    raise NotImplementedError
  end

  def unpaid_fines_for(member_id)
    raise NotImplementedError
  end

  def next_identity
    raise NotImplementedError
  end
end

class InMemoryFineRepository < FineRepository
  def initialize
    @fines = {}
    @next_id = 1
  end

  def save(fine)
    @fines[fine.id] = fine
  end

  def find(id)
    @fines[id]
  end

  def unpaid_fines_for(member_id)
    @fines.values.select { |fine| fine.member_id == member_id && !fine.paid? }
  end

  def next_identity
    id = @next_id
    @next_id += 1
    id
  end
end