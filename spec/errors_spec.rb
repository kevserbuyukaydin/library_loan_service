require_relative "../lib/errors"

RSpec.describe BookNotFoundError do
  it "includes the isbn in the message" do
    error = BookNotFoundError.new("isbn-ghost")
    expect(error.message).to eq("No book with isbn: isbn-ghost")
  end
end

RSpec.describe LoanLimitExceededError do
  it "includes the member_id and limit in the message" do
    error = LoanLimitExceededError.new("member-123", 5)
    expect(error.message).to eq("Member member-123 already holds the maximum of 5 loans")
  end
end

RSpec.describe NoCopiesAvailableError do
  it "includes the isbn in the message" do
    error = NoCopiesAvailableError.new("isbn-ghost")
    expect(error.message).to eq("No copies available for isbn: isbn-ghost")
  end
end

RSpec.describe OutstandingFinesError do
  it "includes the member_id in the message" do
    error = OutstandingFinesError.new("member-123")
    expect(error.message).to eq("Member member-123 has outstanding fines and cannot borrow")
  end
end

RSpec.describe ReservationLimitExceededError do
  it "includes the member_id and limit in the message" do
    error = ReservationLimitExceededError.new("member-123", 3)
    expect(error.message).to eq("Member member-123 already holds the maximum of 3 reservations")
  end
end

RSpec.describe AlreadyReservedError do
  it "includes the member_id and isbn in the message" do
    error = AlreadyReservedError.new("member-1", "isbn-ghost")
    expect(error.message).to eq("Member member-1 already has an active reservation for isbn-ghost")
  end
end