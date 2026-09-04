require_relative "../../lib/entities/book"

RSpec.describe Book do
  describe ".new" do
    it "creates a book with isbn and title" do
      book = Book.new(
        isbn: "isbn-dune",
        title: "Dune"
      )

      expect(book.isbn).to eq("isbn-dune")
      expect(book.title).to eq("Dune")
    end
  end
end