class Book
  attr_reader :isbn, :title

  def initialize(isbn:, title:)
    @isbn = isbn
    @title = title
  end
end