require 'date'

class Loan
  STATUSES = %i[active returned].freeze

  attr_reader :id, :copy_id, :member_id, :borrowed_on, :due_date, :returned_at, :status, :renewal_count

  def initialize(id:, copy_id:, member_id:, borrowed_on:, due_date:, returned_at: nil, status: :active, renewal_count: 0)
    @id = id
    @copy_id = copy_id
    @member_id = member_id
    @borrowed_on = borrowed_on
    @due_date = due_date
    @returned_at = returned_at
    @status = status
    @renewal_count = renewal_count
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

  def renew!(additional_days:)
    @due_date = due_date + additional_days
    @renewal_count += 1
  end

  def overdue?(today)
    today > due_date
  end

  def overdue_at_return?
    returned_at > due_date
  end

  def overdue_days_at_return
    (returned_at - due_date).to_i
  end
end