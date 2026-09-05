class MemberRepository
  def save(member)
    raise NotImplementedError
  end

  def find(id)
    raise NotImplementedError
  end
end

class InMemoryMemberRepository < MemberRepository
  def initialize
    @members = {} 
  end

  def save(member)
    @members[member.id] = member
  end

  def find(id)
    @members[id]
  end
end