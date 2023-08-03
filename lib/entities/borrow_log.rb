class BorrowLog < BaseEntity
  attr_accessor :id, :user_id, :book_id, :borrow_time, :return_time

  def initialize(log_data)
    self.id = log_data[:id]
    self.user_id = log_data[:user_id]
    self.book_id = log_data[:book_id]
    self.borrow_time = log_data[:borrow_time]
    self.return_time = log_data[:return_time]
  end

  def save
    begin
      @@db.exec_params('UPDATE borrow_logs SET user_id = $1, book_id = $2, borrow_time = $3, return_time = $4 WHERE id = $5;',[user_id, book_id, borrow_time, return_time, id])
    rescue PG::Error=> e
      puts "Error occurred while updating book: #{e.message}"
    end
  end

  def self.find_by_id(user_id, book_id)
    begin
      result = @@db.exec_params('SELECT * FROM borrow_logs WHERE book_id = $1 AND user_id = $2;', [book_id, user_id]).first
      if result
        BorrowLog.new(id: result['id'], user_id: result['user_id'], book_id: result['book_id'], borrow_time: result['borrow_time'], return_time: result['return_time'])
      end
    rescue PG::Error => e
      puts "Error occurred while fetching book by ID: #{e.message}"
    end
  end

  def create
    begin
      @@db.exec_params('INSERT INTO borrow_logs (user_id, book_id, borrow_time, return_time) VALUES ($1, $2, $3, $4);', [user_id, book_id, borrow_time, return_time])
    rescue PG::Error => e
      puts "Error occurred while creating book: #{e.message}"
    end
  end

  def self.list_logs(user_id)
    begin
      result = @@db.exec_params('SELECT * FROM borrow_logs WHERE user_id = $1;', [user_id])
      logs_array = []
      result.each do |row|
        log_data = {
          id: row['id'],
          user_id: row['user_id'],
          book_id: row['book_id'],
          borrow_time: row['borrow_time'],
          return_time: row['return_time'],
        }
        logs_array << BorrowLog.new(log_data)
      end
      logs_array
    rescue PG::Error => e
      puts "Error occurred while fetching available books: #{e.message}"
      []
    end
  end
end
