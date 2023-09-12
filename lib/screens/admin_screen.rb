class AdminScreen
  attr_accessor :current_user

  def admin_menu(current_user)
    self.current_user = current_user
    display_admin_message
    choice = 0
    while choice != 6
      puts "ADMIN MENU"
      puts "-----------------------------------------"
      puts "1. Add a New Book"
      puts "2. Restock a Book"
      puts "3. Soft Delete a Book"
      puts "4. Show All Books"
      puts "5. Logout"
      puts "6. Exit"
      print "Enter your choice: "

      choice = gets.chomp.to_i
      display_admin_message
      case choice
      when 1
        add_new_book
      when 2
        restock_book
      when 3
        soft_delete_book
      when 4
        show_all_books
      when 5
        current_user = nil
        puts "Logged out successfully!\n"
        break
      when 6
        puts "Goodbye! Exiting the Library Management System."
        exit(0)
      else
        puts "Invalid choice. Please try again."
      end
    end
  end

  private
  def display_admin_message
    system('clear')
    puts "Welcome #{current_user.username}"
    puts "-----------------------------------------"
  end

  private
  def add_new_book
    puts "ADD A NEW BOOK"
    puts "-----------------------------------------"
    title = BookHelper.parse_title
    genre = BookHelper.parse_genre
    author = BookHelper.parse_author
    publish_date = BookHelper.parse_publish_date
    count = BookHelper.parse_count
    BookController.create(
      title: title,
      genre: genre,
      author: author,
      publish_date: publish_date,
      count: count
    )
    puts "New book '#{title}' has been added to the inventory."
    puts "Press enter to go back to the admin menu."
    gets
    display_admin_message
  end

  private
  def restock_book
    puts "RETSOCK A BOOK"
    puts "-----------------------------------------"
    book_id = BookHelper.parse_book_id('restock')
    book = BookController.find_by_id(book_id)
    if book.nil?
      puts "Book with ID #{book_id} not found."
    else
      print "Enter the quantity to add : "
      quantity_to_add = gets.chomp.to_i
      if quantity_to_add <= 0
        puts "Quantity must be a positive number."
      else
        new_count = book.count.to_i + quantity_to_add
        BookController.restock(book, new_count)
        puts "Book '#{book.title}' has been restocked.\n"
      end
    end
    puts "Press enter to go back to the admin menu."
    gets
    display_admin_message
  end

  private
  def soft_delete_book
    puts "DELETE A BOOK"
    puts "-----------------------------------------"
    book_id = BookHelper.parse_book_id('delete')
    book = BookController.find_by_id(book_id)
    if book.nil?
      puts "Book with ID #{book_id} not found."
    else
      BookController.soft_delete(book)
      puts "Book '#{book.title}' has been soft deleted."
    end
    puts "Press enter to go back to the admin menu."
    gets
    display_admin_message
  end

  private
  def show_all_books
    puts "AVAILABLE BOOKS : "
    books = BookController.list_inventory
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
    display_admin_message
  end
end
