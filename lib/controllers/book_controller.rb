class BookController
  def self.find_by_id(book_id)
    Book.find_by_id(book_id)
  end

  def self.list_inventory
    Book.list_inventory
  end

  def self.list_available
    Book.list_available
  end

  def self.create(book_data)
    Book.new(book_data).create
  end

  def self.restock(book, new_count)
    book.count = new_count
    book.save
  end

  def self.soft_delete(book_id)
    Book.delete(book_id)
  end
end
