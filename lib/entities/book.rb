class Book < BaseEntity
  attr_accessor :id, :title, :genre, :author, :publish_date, :count

  def initialize(book_data)
    self.id = book_data[:id]
    self.title = book_data[:title]
    self.genre = book_data[:genre]
    self.author = book_data[:author]
    self.publish_date = book_data[:publish_date]
    self.count = book_data[:count]
  end

  def create
    begin
      BaseEntity.db.exec_params('INSERT INTO books (title, genre, author, publish_date, count) VALUES ($1, $2, $3, $4, $5);', [title, genre, author, publish_date, count])
    rescue PG::Error => e
      puts "Error occurred while creating book: #{e.message}"
    end
  end

  def self.list_available
    begin
      result = BaseEntity.db.exec('SELECT * FROM books WHERE count > 0 AND NOT deleted;')
      books_array = []
      result.each do |row|
        book_data = {
          id: row['id'],
          title: row['title'],
          genre: row['genre'],
          author: row['author'],
          publish_date: row['publish_date'],
          count: row['count']
        }
        books_array << new(book_data)
      end
      books_array
    rescue PG::Error => e
      puts "Error occurred while fetching available books: #{e.message}"
      []
    end
  end

  def self.find_by_id(book_id)
    begin
      result = BaseEntity.db.exec_params('SELECT * FROM books WHERE id = $1 AND NOT deleted;', [book_id]).first
      if result
        new(result.transform_keys(&:to_sym))
      end
    rescue PG::Error => e
      puts "Error occurred while fetching book by ID: #{e.message}"
    end
  end

  def self.list_inventory
    begin
      result = BaseEntity.db.exec('SELECT * FROM books WHERE NOT deleted;')
      books_array = []
      result.each do |row|
        book_data = row.transform_keys(&:to_sym)
        books_array << new(book_data)
      end
      books_array
    rescue PG::Error => e
      puts "Error occurred while fetching available books: #{e.message}"
      []
    end
  end

  def save
    begin
      BaseEntity.db.exec_params('UPDATE books SET title = $1, genre = $2, author = $3, publish_date = $4, count = $5 WHERE id = $6;',[title, genre, author, publish_date, count, id])
    rescue PG::Error=> e
      puts "Error occurred while updating book: #{e.message}"
    end
  end

  def self.delete(book_id)
    begin
      BaseEntity.db.exec_params('UPDATE books SET deleted = true WHERE id = $1 RETURNING *;', [book_id])
    rescue PG::Error => e
      puts "Error occurred while soft deleting book: #{e.message}"
    end
  end
end
