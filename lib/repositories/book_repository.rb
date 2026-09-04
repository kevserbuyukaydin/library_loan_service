class BookRepository
  def save(book)
    raise NotImplementedError
  end

  def find(isbn)
    raise NotImplementedError
  end
end

class InMemoryBookRepository < BookRepository
  def initialize
    @books = {} 
  end

  def save(book)
    @books[book.isbn] = book
  end

  def find(isbn)
    @books[isbn]
  end
end