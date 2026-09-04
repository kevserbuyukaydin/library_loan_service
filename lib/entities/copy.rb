require 'date'

class Copy
  STATUSES = %i[available on_loan held].freeze

  attr_reader :id, :isbn, :status, :held_at

  def initialize(id:, isbn:, status: :available, held_at: nil)
    @id = id
    @isbn = isbn
    @status = status
    @held_at = held_at
  end

  def available?
    status == :available
  end

  def on_loan?
    status == :on_loan
  end

  def held?
    status == :held
  end

  def loan!
    @status = :on_loan
    @held_at = nil
  end

  def return!
    @status = :available
    @held_at = nil
  end

  def hold!(on:)
    @status = :held
    @held_at = on
  end

  def release_hold!
    @status = :available
    @held_at = nil
  end

  def hold_expired?(today, expiry_days: 3)
    return false unless held?
    (today - held_at).to_i > expiry_days
  end
end