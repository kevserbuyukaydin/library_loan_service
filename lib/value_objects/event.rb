require 'time'

class Event
  attr_reader :action, :member_id, :occurred_at, :details

  def initialize(action:, member_id:, occurred_at:, details: {})
    @action = action
    @member_id = member_id
    @occurred_at = occurred_at
    @details = details
  end
end