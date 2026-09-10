require_relative "../../lib/services/catalogue_service"
require_relative "../../lib/repositories/copy_repository"
require_relative "../../lib/entities/copy"
require_relative "../../lib/ports/clock"
require_relative "../../lib/errors"

RSpec.describe CatalogueService do
  describe "#add_copy" do
    it "creates a new copy with the given ISBN and in available status" do
      copy_repo = InMemoryCopyRepository.new
      clock = FixedClock.new(Date.new(2026, 9, 10))
      service = CatalogueService.new(
        copy_repository: copy_repo, 
        clock: clock
      )

      copy = service.add_copy(isbn: "isbn-dune")

      expect(copy.status).to eq(:available)
      expect(copy_repo.find(copy.id)).to eq(copy)
    end
  end

  describe "#withdraw_copy" do
    it "sets the copy status to withdrawn" do
      copy_repo = InMemoryCopyRepository.new
      clock = FixedClock.new(Date.new(2026, 9, 10))
      service = CatalogueService.new(
        copy_repository: copy_repo, 
        clock: clock
      )

      copy = service.add_copy(isbn: "isbn-dune")
      service.withdraw_copy(copy.id)

      expect(copy.status).to eq(:withdrawn)
      expect(copy_repo.find(copy.id)).to eq(copy)
    end

    it "raises CopyInUseError when the copy is on loan" do
      copy_repo = InMemoryCopyRepository.new
      clock = FixedClock.new(Date.new(2026, 9, 10))
      service = CatalogueService.new(
        copy_repository: copy_repo, 
        clock: clock
      )

      copy = service.add_copy(isbn: "isbn-dune")
      copy.loan!
      copy_repo.save(copy)  

      expect {
        service.withdraw_copy(copy.id)
      }.to raise_error(CopyInUseError, "Copy #{copy.id} is currently in use and cannot be withdrawn")    
    end

    it "raises CopyInUseError when the copy is held" do
      copy_repo = InMemoryCopyRepository.new
      clock = FixedClock.new(Date.new(2026, 9, 10))
      service = CatalogueService.new(
        copy_repository: copy_repo, 
        clock: clock
      )

      copy = service.add_copy(isbn: "isbn-dune")
      copy.hold!(on: Date.today, member_id: "member-1")
      copy_repo.save(copy)
      
      expect {
        service.withdraw_copy(copy.id)
      }.to raise_error(CopyInUseError, "Copy #{copy.id} is currently in use and cannot be withdrawn") 
    end
  end
end

