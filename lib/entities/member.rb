class Member
  attr_reader :id, :email, :tier

  def initialize(id:, email:, tier:)
    @id = id
    @email = email
    @tier = tier
  end
end