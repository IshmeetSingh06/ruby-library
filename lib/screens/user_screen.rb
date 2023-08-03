class UserScreen
  attr_accessor :current_user

  def display_message
    system('clear')
    puts "Welcome #{current_user.username}"
    puts "-----------------------------------------"
  end

  def main_menu(current_user)
    self.current_user = current_user
    display_message
    choice = 0
    while choice != 5
      puts "Main Menu"
      puts "1. View Available Books"
      puts "2. Borrow a Book"
      puts "3. Return a Book"
      puts "4. View Borrowed Books"
      puts "5. Logout"
      puts "6. Exit"
      print "Enter your choice: "

      choice = gets.chomp.to_i
      display_message
      case choice
      when 1
        view_available_books
      when 2
        borrow_book
      when 3
        return_book
      when 4
        view_borrowed_books
      when 5
        current_user = nil
        puts "Logged out successfully!\n"
      when 6
        puts "Goodbye! Exiting the Library Management System."
        exit(0)
      else
        puts "Invalid choice please try again."
      end
    end
  end

  def view_available_books
    puts "Available Books : "
    books = BookController.list_available
    if books.empty?
      puts "No books available please come back later."
    else
      puts "----------------------------------------------------------------"
      puts "ID\tTitle\tGenre\tAuthor\tPublish-Date\tCount"
      puts "----------------------------------------------------------------"
      books.each do |book|
        puts "#{book.id}\t#{book.title}\t#{book.genre}\t#{book.author}\t#{book.publish_date}\t#{book.count}"
      end
      puts "----------------------------------------------------------------"
    end
    puts "Press enter to go back to the main menu."
    gets
  end

  def view_borrowed_books
    puts "Borrowed Books : "
    borrowed_log = BorrowLogController.find_borrowed_books(current_user.id)
    if borrowed_log.empty?
      puts "You have not borrowed any boooks yet."
    else
      puts "------------------------------------------------------------"
      puts "ID\tBookID\tUserID\tBorrowTime\tReturnTime"
      puts "------------------------------------------------------------"
      borrowed_log.each do |log|
        puts "#{log.id}\t#{log.book_id}\t#{log.user_id}\t#{log.borrow_time}\t#{log.return_time}"
      end
      puts "------------------------------------------------------------"
    end
    puts "Press enter to go back to the main menu."
    gets
  end

  def borrow_book
    puts "Borrow a Book"
    print "Enter the id of the book you want to borrow: "
    book_id = gets.chomp.to_i
    book = BookController.find_by_id(book_id)
    log = BorrowLogController.find_by_ref_id(current_user.id, book_id)
    if book.nil?
      puts "Book with ID #{book_id} not found."
    elsif !log.nil? || log.return_time.nil?
      puts "You have already borrowed this book please return it to borrow again"
    else
      puts "You are about to borrow '#{book.title}'."
      borrow_time = Time.now.strftime('%Y-%m-%d %H:%M:%S')
      return_time = nil
      BorrowLogController.create(user_id: current_user.id, book_id: book_id, borrow_time: borrow_time, return_time: return_time)
      new_count = book.count.to_i - 1
      BookController.restock(book, new_count)
      puts "Book '#{book.title}' has been successfully borrowed."
    end
    puts "Press enter to go back to the main menu."
    gets
  end

  def return_book
    puts "Return a Book"
    print "Enter the id of the book you want to return: "
    book_id = gets.chomp.to_i
    book = BookController.find_by_id(book_id)
    log = BorrowLogController.find_by_ref_id(current_user.id, book_id)
    if book.nil?
      puts "Book with ID #{book_id} not found."
    elsif log.nil?
      puts "You have not borrowed this book!"
    else
      BorrowLogController.return(log)
      new_count = book.count.to_i + 1
      BookController.restock(book, new_count)
      puts "Book '#{book.title}' has been successfully returned."
    end
    puts "Press enter to go back to the main menu."
    gets
  end
end
