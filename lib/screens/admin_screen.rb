class AdminScreen
  attr_accessor :current_user, :book_controller

  def initialize(connection)
    self.current_user = nil
    self.book_controller = BookController.new(connection)
  end

  def display_admin_message
    system('clear')
    puts "Welcome #{current_user['username']}"
    puts "-----------------------------------------"
  end

  def admin_menu(current_user)
    self.current_user = current_user

    display_admin_message
    choice = 0
    while choice != 6
      puts "Admin Menu"
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

  def add_new_book
    puts "Add a New Book"
    puts "-----------------------------------------"
    print "Enter title : "
    title = gets.chomp
    print "Enter genre : "
    genre = gets.chomp
    print "Enter author : "
    author = gets.chomp
    print "Enter publish date (dd/mm/yyyy, press enter if unknown) : "
    publish_date = gets.chomp

    # TODO: Implement adding a new book to the inventory
    puts "New book '#{title}' has been added to the inventory."
    puts "Press enter to go back to the admin menu."
    gets
  end

  def restock_book
    puts "Restock a Book"
    puts "-----------------------------------------"
    print "Enter the id of the book you want to restock : "
    book_id = gets.chomp.to_i

    book = book_controller.get_book_by_id(book_id)

    if book.nil?
      puts "Book with ID #{book_id} not found."
    else
      print "Enter the quantity to add : "
      quantity_to_add = gets.chomp.to_i

      if quantity_to_add <= 0
        puts "Quantity must be a positive number."
      else
        # TODO: Implement restocking the book
        new_count = book['count'] + quantity_to_add
        book_controller.update_book_count(book_id, new_count)

        puts "Book '#{book['title']}' has been restocked."
      end
    end

    puts "Press enter to go back to the admin menu."
    gets
  end

  def soft_delete_book
    puts "Delete a Book"
    puts "-----------------------------------------"
    print "Enter the id of the book you want to delete : "
    book_id = gets.chomp.to_i

    book = book_controller.get_book_by_id(book_id)

    if book.nil?
      puts "Book with ID #{book_id} not found."
    else
      # TODO: Implement soft deleting the book
      puts "Book '#{book['title']}' has been soft deleted."
    end

    puts "Press enter to go back to the admin menu."
    gets
  end

  def show_all_books
    puts "Available Books:"
    books = book_controller.get_available_books

    if books.empty?
      puts "No books available in the inventory."
    else
      puts "-----------------------------------"
      puts "ID\tTitle\t\tGenre\tAuthor\tCount"
      puts "-----------------------------------"
      books.each do |book|
        puts "#{book['id']}\t#{book['title']}\t#{book['genre']}\t#{book['author']}\t#{book['count']}"
      end
      puts "-----------------------------------"
    end

    puts "Press enter to go back to the main menu."
    gets
  end
end
