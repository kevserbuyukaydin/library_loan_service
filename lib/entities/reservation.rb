require 'date'

class Reservation
  attr_reader :id, :isbn, :member_id, :requested_on

  def initialize(id:, isbn:, member_id:, requested_on:)
    @id = id
    @isbn = isbn
    @member_id = member_id
    @requested_on = requested_on
  end
end