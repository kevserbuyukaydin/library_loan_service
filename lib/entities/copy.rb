require 'date'

class Copy
  STATUSES = %i[available on_loan held withdrawn].freeze

  attr_reader :id, :isbn, :status, :held_at, :held_for_member_id, :withdrawn_at

  def initialize(id:, isbn:, status: :available, held_at: nil, held_for_member_id: nil, withdrawn_at: nil)
    @id = id
    @isbn = isbn
    @status = status
    @held_at = held_at
    @held_for_member_id = held_for_member_id
    @withdrawn_at = withdrawn_at
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

  def withdrawn?
    status == :withdrawn
  end

  def in_use?
    on_loan? || held?
  end

  def loan!
    @status = :on_loan
    @held_at = nil
    @held_for_member_id = nil
  end

  def return!
    @status = :available
    @held_at = nil
    @held_for_member_id = nil
  end

  def hold!(on:, member_id:)
    @status = :held
    @held_at = on
    @held_for_member_id = member_id
  end

  def release_hold!
    @status = :available
    @held_at = nil
    @held_for_member_id = nil
  end
  
  def withdraw!(on:)
    @status = :withdrawn
    @withdrawn_at = on
  end

  def hold_expired?(today, expiry_days: 3)
    return false unless held?
    (today - held_at).to_i > expiry_days
  end
end