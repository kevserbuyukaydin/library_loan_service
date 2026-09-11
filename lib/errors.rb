class BookNotFoundError < StandardError
  def initialize(isbn)
    super("No book with isbn: #{isbn}")
  end
end

class LoanLimitExceededError < StandardError
  def initialize(member_id, limit)
    super("Member #{member_id} already holds the maximum of #{limit} loans")
  end
end

class NoCopiesAvailableError < StandardError
  def initialize(isbn)
    super("No copies available for isbn: #{isbn}")
  end
end

class OutstandingFinesError < StandardError
  def initialize(member_id)
    super("Member #{member_id} has outstanding fines and cannot borrow")
  end
end

class ReservationLimitExceededError < StandardError
  def initialize(member_id, limit)
    super("Member #{member_id} already holds the maximum of #{limit} reservations")
  end
end

class AlreadyReservedError < StandardError
  def initialize(member_id, isbn)
    super("Member #{member_id} already has an active reservation for #{isbn}")
  end
end

class CopyInUseError < StandardError
  def initialize(copy_id)
    super("Copy #{copy_id} is currently in use and cannot be withdrawn")
  end
end

class CopyNotFoundError < StandardError
  def initialize(copy_id)
    super("No copy with id: #{copy_id}")
  end
end

class MemberNotFoundError < StandardError
  def initialize(member_id)
    super("No member with id: #{member_id}")
  end
end