class BorrowingEligibilityPolicy
  def eligible?(member_id)
    raise NotImplementedError
  end
end

class DefaultBorrowingEligibilityPolicy < BorrowingEligibilityPolicy
  def initialize(fine_repository)
    @fine_repository = fine_repository
  end

  def eligible?(member_id)
    @fine_repository.unpaid_fines_for(member_id).empty?
  end
end