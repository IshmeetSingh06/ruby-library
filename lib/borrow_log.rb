class BorrowLog
  attr_reader :id
  attr_accessor :user_id, :book_id, :borrow_time, :return_time
  
  def initialize(user_id, book_id, borrow_time, return_time = nil)
    @user_id = user_id
    @book_id = book_id
    @borrow_time = borrow_time
    @return_time = return_time
  end
end