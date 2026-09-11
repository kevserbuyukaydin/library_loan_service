require 'date'

class Reservation
  STATUSES = %i[pending awaiting_pickup].freeze

  attr_reader :id, :isbn, :member_id, :requested_at, :status

  def initialize(id:, isbn:, member_id:, requested_at:, status: :pending)
    @id = id
    @isbn = isbn
    @member_id = member_id
    @requested_at = requested_at
    @status = status
  end

  def pending?
    status == :pending
  end

  def awaiting_pickup?
    status == :awaiting_pickup
  end

  def open?
    pending? || awaiting_pickup?
  end

  def mark_as_awaiting_pickup!
    @status = :awaiting_pickup
  end
end