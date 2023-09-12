class UserScreen
  attr_accessor :current_user

  def main_menu(current_user)
    self.current_user = current_user
    display_message
    choice = 0
    while choice != 5
      puts "MAIN MENU"
      puts "-----------------------------------------"
      puts "1. View Available Books"
      puts "2. Borrow a Book"
      puts "3. Return a Book"
      puts "4. View Borrowed Books"
      puts "5. Edit your Account"
      puts "6. Logout"
      puts "7. Exit"
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
        edit_account
      when 6
        current_user = nil
        puts "Logged out successfully!\n"
        break
      when 7
        puts "Goodbye! Exiting the Library Management System."
        exit(0)
      else
        puts "Invalid choice please try again."
      end
    end
  end

  private
  def display_message
    system('clear')
    puts "Welcome #{current_user.username}"
    puts "-----------------------------------------"
  end

  private
  def view_available_books
    puts "AVAILABLE BOOKS : "
    books = BookController.list_available
    if books.empty?
      puts "No books available in the inventory."
    else
      puts "-" * 85
      puts sprintf(
        "%-5s%-20s%-20s%-20s%-15s%-5s",
        "ID", "TITLE", "GENRE", "AUTHOR", "PUBLISH DATE", "COUNT"
      )
      puts "-" * 85
      books.each do |book|
        puts sprintf(
          "%-5s%-20s%-20s%-20s%-15s%-5s",
          book.id, book.title, book.genre, book.author, book.publish_date, book.count
        )
      end
      puts "-" * 85
    end
    puts "Press enter to go back to the main menu."
    gets
    display_message
  end

  private
  def view_borrowed_books
    puts "BORROWED BOOKS : "
    borrowed_logs = BorrowLogController.find_borrowed_books(current_user.id)
    if borrowed_logs.empty?
      puts "No books available in the inventory."
    else
      puts "-" * 55
      puts sprintf(
        "%-5s%-10s%-10s%-15s%-15s",
        "ID", "BOOK ID", "USER ID", "BORROW TIME", "RETURN TIME"
      )
      puts "-" * 55
      borrowed_logs.each do |log|
        puts sprintf(
          "%-5s%-10s%-10s%-15s%-15s",
          log.id, log.book_id, log.user_id, log.borrow_time, log.return_time
        )
      end
      puts "-" * 55
    end
    puts "Press enter to go back to the main menu."
    gets
    display_message
  end

  private
  def borrow_book
    puts "BORROW A BOOK"
    puts "-----------------------------------------"
    book_id = BookHelper.parse_book_id('borrow')
    book = BookController.find_by_id(book_id)
    log = BorrowLogController.find_by_ref_id(current_user.id, book_id)
    if book.nil?
      puts "Book with ID #{book_id} not found."
    elsif log && log.return_time.nil?
      puts "You have already borrowed this book please return it to borrow again"
    else
      borrow_time = Time.now.strftime('%Y-%m-%d %H:%M:%S')
      return_time = nil
      BorrowLogController.create(
        user_id: current_user.id,
        book_id: book_id,
        borrow_time: borrow_time,
        return_time: return_time
      )
      new_count = book.count.to_i - 1
      BookController.restock(book, new_count)
      puts "Book '#{book.title}' has been successfully borrowed."
    end
    puts "Press enter to go back to the main menu."
    gets
    display_message
  end

  private
  def return_book
    puts "RETURN A BOOK"
    puts "-----------------------------------------"
    book_id = BookHelper.parse_book_id('return')
    book = BookController.find_by_id(book_id)
    log = BorrowLogController.find_by_ref_id(current_user.id, book_id)
    if book.nil?
      puts "Book with ID #{book_id} not found."
    elsif log.nil?
      puts "You have not borrowed this book!"
    elsif log && log.return_time
      puts "You have returned this book already!"
    else
      BorrowLogController.return(log)
      new_count = book.count.to_i + 1
      BookController.restock(book, new_count)
      puts "Book '#{book.title}' has been successfully returned."
    end
    puts "Press enter to go back to the main menu."
    gets
    display_message
  end

  private
  def edit_account
    puts "EDIT ACCOUNT"
    puts "-----------------------------------------"
    puts "Please enter the new details"
    password = UserHelper.parse_password
    first_name = UserHelper.parse_first_name
    last_name = UserHelper.parse_last_name
    result = UserController.update(
      id: current_user.id,
      username: current_user.username,
      password: password,
      first_name: first_name,
      last_name: last_name
    )
    if result
      puts "\nUpdation successful!"
      current_user = result
      main_menu(current_user)
    else
      puts "Updation failed, exiting the program"
      exit(1)
    end
  end
end
