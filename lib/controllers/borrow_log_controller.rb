class BorrowLogController
  def self.find_borrowed_books(user_id)
    BorrowLog.list_logs(user_id)
  end

  def self.create(borrow_log)
    BorrowLog.new(borrow_log).save
  end

  def self.return(log)
    log.return_time = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    log.save
  end

  def self.find_by_ref_id(user_id, book_id)
    BorrowLog.find_by_id(user_id, book_id)
  end
end
