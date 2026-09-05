require 'date'

class Reservation
  STATUSES = %i[pending fulfilled].freeze

  attr_reader :id, :isbn, :member_id, :requested_on, :status

  def initialize(id:, isbn:, member_id:, requested_on:, status: :pending)
    @id = id
    @isbn = isbn
    @member_id = member_id
    @requested_on = requested_on
    @status = status
  end

  def pending?
    status == :pending
  end

  def fulfilled?
    status == :fulfilled
  end

  def fulfill!
    @status = :fulfilled
  end
end