require 'date'

class Loan
  STATUSES = %i[active returned].freeze

  attr_reader :id, :copy_id, :member_id, :borrowed_on, :due_date, :returned_at, :status

  def initialize(id:, copy_id:, member_id:, borrowed_on:, due_date:, returned_at: nil, status: :active)
    @id = id
    @copy_id = copy_id
    @member_id = member_id
    @borrowed_on = borrowed_on
    @due_date = due_date
    @returned_at = returned_at
    @status = status
  end

  def active?
    status == :active
  end

  def returned?
    status == :returned
  end

  def return!(on:)
    @status = :returned
    @returned_at = on
  end

  def overdue?(today)
    today > due_date
  end
end