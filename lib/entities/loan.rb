require 'date'

class Loan
  attr_reader :id, :copy_id, :member_id, :borrowed_on, :due_date

  def initialize(id:, copy_id:, member_id:, borrowed_on:, due_date:)
    @id = id
    @copy_id = copy_id
    @member_id = member_id
    @borrowed_on = borrowed_on
    @due_date = due_date
  end

  def overdue?(today)
    today > due_date
  end
end