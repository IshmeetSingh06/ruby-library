class BookController
  attr_accessor :db

  def initialize(connection)
    self.db = connection
  end

  def find_by_id(book_id)
    begin
      result = db.exec_params('SELECT * FROM books WHERE id = $1 AND NOT deleted;', [book_id])
      result.first
    rescue PG::Error => e
      puts "Error occurred while fetching book by ID: #{e.message}"
      nil
    end
  end

  def list_inventory
    begin
      result = db.exec('SELECT * FROM books WHERE count >= 0 AND NOT deleted;')
      result.to_a
    rescue PG::Error => e
      puts "Error occurred while fetching available books: #{e.message}"
      []
    end
  end

  def list_available
    begin
      result = db.exec('SELECT * FROM books WHERE count > 0 AND NOT deleted;')
      result.to_a
    rescue PG::Error => e
      puts "Error occurred while fetching available books: #{e.message}"
      []
    end
  end

  def create(bookData)
    begin
      result = db.exec_params('INSERT INTO books (title, genre, author, publish_date, count) VALUES ($1, $2, $3, $4, $5) RETURNING *;', [bookData[:title], bookData[:genre], bookData[:author], bookData[:publish_date], bookData[:count]])
      result.first
    rescue PG::Error => e
      puts "Error occurred while creating book: #{e.message}"
      nil
    end
  end

  def restock(book_id, new_count)
    begin
      result = db.exec_params('UPDATE books SET count = $1 WHERE id = $2 RETURNING *;', [new_count, book_id])
      result.first
    rescue PG::Error => e
      puts "Error occurred while restocking book: #{e.message}"
      nil
    end
  end

  def soft_delete(book_id)
    begin
      result = db.exec_params('UPDATE books SET deleted = true WHERE id = $1 RETURNING *;', [book_id])
      result.first
    rescue PG::Error => e
      puts "Error occurred while soft deleting book: #{e.message}"
      nil
    end
  end
end
