class BookController
  def find_by_id(book_id)
    Book.find_by_id(book_id)
  end

  def list_inventory
    Book.list_inventory
  end

  def list_available
    Book.list_available
  end

  def create(book_data)
    Book.new(book_data).create
  end

  def restock(book_id, new_count)
    Book.restock(book_id,new_count)
  end

  def soft_delete(book_id)
    Book.delete(book_id)
  end
end
