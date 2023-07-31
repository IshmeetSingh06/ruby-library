class BorrowLog
  attr_reader :id
  attr_accessor :user_id, :book_id, :borrow_time, :return_time
  
  def initialize(user_id, book_id, borrow_time, return_time = nil)
    self.user_id = user_id
    self.book_id = book_id
    self.borrow_time = borrow_time
    self.return_time = return_time
  end
end