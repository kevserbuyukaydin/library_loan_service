class Fine
  attr_reader :id, :member_id, :amount, :paid

  def initialize(id:, member_id:, amount:, paid: false)
    @id = id
    @member_id = member_id
    @amount = amount
    @paid = paid
  end

  def paid?
    paid
  end

  def mark_as_paid!
    @paid = true
  end
end