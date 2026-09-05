class CopyRepository
  def save(copy)
    raise NotImplementedError
  end

  def find(id)
    raise NotImplementedError
  end

  def copies_for_book(isbn)
    raise NotImplementedError
  end

  def available_copy_for(isbn)
    raise NotImplementedError
  end

  def held_copy_for(isbn:, member_id:)
    raise NotImplementedError
  end

  def held_copies_for(isbn)
    raise NotImplementedError
  end

  def next_identity
    raise NotImplementedError
  end
end

class InMemoryCopyRepository < CopyRepository
  def initialize
    @copies = {}
    @next_id = 1
  end

  def save(copy)
    @copies[copy.id] = copy
  end

  def find(id)
    @copies[id]
  end

  def copies_for_book(isbn)
    @copies.values.select { |copy| copy.isbn == isbn }
  end

  def available_copy_for(isbn)
    @copies.values.find { |copy| copy.isbn == isbn && copy.available? }
  end

  def held_copy_for(isbn:, member_id:)
    @copies.values.find do |copy|
      copy.isbn == isbn && copy.held? && copy.held_for_member_id == member_id
    end  
  end

  def held_copies_for(isbn)
    @copies.values.select { |copy| copy.isbn == isbn && copy.held? }
  end

  def next_identity
    id = @next_id
    @next_id += 1
    id
  end
end