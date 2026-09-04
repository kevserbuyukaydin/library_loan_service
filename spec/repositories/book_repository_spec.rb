require_relative "../../lib/entities/book"
require_relative "../../lib/repositories/book_repository"

RSpec.describe BookRepository do
  describe "#save" do
    it "raises NotImplementedError" do
      book = Book.new(isbn: "isbn-dune", title: "Dune")

      expect {
        BookRepository.new.save(book)
      }.to raise_error(NotImplementedError)
    end
  end

  describe "#find" do
    it "raises NotImplementedError" do
      expect {
        BookRepository.new.find("isbn-dune")
      }.to raise_error(NotImplementedError)
    end
  end
end

RSpec.describe InMemoryBookRepository do
  describe "#save and #find" do
    it "returns the saved book by isbn" do
      repo = InMemoryBookRepository.new
      book = Book.new(isbn: "isbn-dune", title: "Dune")

      repo.save(book)

      expect(repo.find("isbn-dune")).to eq(book)
    end
  end

  describe "#find" do
    it "returns nil when the book is not found" do
      repo = InMemoryBookRepository.new

      expect(repo.find("isbn-ghost")).to be_nil
    end
  end
end