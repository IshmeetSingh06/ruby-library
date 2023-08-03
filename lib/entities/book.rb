class Book < BaseEntity
  attr_reader :id
  attr_accessor :title, :genre, :author, :publish_date, :count

  def initialize(book_data)
    self.title = book_data[:title]
    self.genre = book_data[:genre]
    self.author = book_data[:author]
    self.publish_date = books_data[:publish_date]
    self.count = book_data[:count]
  end

  def create
    begin
      result = db.exec_params('INSERT INTO books (title, genre, author, publish_date, count) VALUES ($1, $2, $3, $4, $5) RETURNING *;', [title, genre, author, publish_date, count])
      result.first
    rescue PG::Error => e
      puts "Error occurred while creating book: #{e.message}"
      nil
    end
  end

  def self.list_available
    begin
      result = db.exec('SELECT * FROM books WHERE count > 0 AND NOT deleted;')
      result.to_a
    rescue PG::Error => e
      puts "Error occurred while fetching available books: #{e.message}"
      []
    end
  end

  def self.find_by_id(book_id)
    begin
      result = db.exec_params('SELECT * FROM books WHERE id = $1 AND NOT deleted;', [book_id])
      result.first
    rescue PG::Error => e
      puts "Error occurred while fetching book by ID: #{e.message}"
      nil
    end
  end

  def self.list_inventory
    begin
      result = db.exec('SELECT * FROM books WHERE count >= 0 AND NOT deleted;')
      result.to_a
    rescue PG::Error => e
      puts "Error occurred while fetching available books: #{e.message}"
      []
    end
  end

  def self.restock(book_id, new_count)
    begin
      result = db.exec_params('UPDATE books SET count = $1 WHERE id = $2 RETURNING *;', [new_count, book_id])
      result.first
    rescue PG::Error => e
      puts "Error occurred while restocking book: #{e.message}"
      nil
    end
  end

  def self.delete(book_id)
    begin
      result = db.exec_params('UPDATE books SET deleted = true WHERE id = $1 RETURNING *;', [book_id])
      result.first
    rescue PG::Error => e
      puts "Error occurred while soft deleting book: #{e.message}"
      nil
    end
  end
end
