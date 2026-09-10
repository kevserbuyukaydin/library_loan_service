require_relative "../entities/copy"

class CatalogueService
  def initialize(book_repository:, copy_repository:, clock:)
    @book_repository = book_repository
    @copy_repository = copy_repository
    @clock = clock
  end

  def add_copy(isbn:)
    book = @book_repository.find(isbn)
    raise BookNotFoundError.new(isbn) if book.nil?

    copy = Copy.new(id: @copy_repository.next_identity, isbn: isbn)
    @copy_repository.save(copy)
    copy
  end

  def withdraw_copy(copy_id)
    copy = find_copy(copy_id)
    raise CopyInUseError.new(copy_id) if copy.in_use?

    copy.withdraw!(on: @clock.today)
    @copy_repository.save(copy)
  end

  private

  def find_copy(copy_id)
    copy = @copy_repository.find(copy_id)
    raise CopyNotFoundError.new(copy_id) if copy.nil?
    copy
  end
end