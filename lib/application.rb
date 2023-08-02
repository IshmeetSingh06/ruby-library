class LibraryApp
  attr_accessor :current_user, :user_controller

  def initialize
    self.current_user = nil
    self.user_controller = UserController.new
    self.book_controller = BookController.new
  end

  def start
    display_welcome_message
    login_or_register_menu
  end

  private

  def display_welcome_message
    system('clear')
    puts "Welcome to the Library Management System!"
    puts "-----------------------------------------"
  end

  def login_or_register_menu
    choice = 0
    while choice != 3
      puts "Please select an option:"
      puts "1. Login"
      puts "2. Register"
      puts "3. Exit"
      print "Please enter your choice : "

      choice = gets.chomp.to_i

      display_welcome_message
      case choice
      when 1
        login_user
      when 2
        register_user
      when 3
        puts "Goodbye! Exiting the Library Management System.\n"
        exit(0)
      else
        puts "Invalid choice please enter again."
      end
    end
  end

  private def login_user
    puts "Login"
    puts "-----------------------------------------"
    print "Enter username : "
    username = gets.chomp
    print "Enter password : "
    password = gets.chomp

    user = user_controller.get_user_by_username(username)

    if user && BCrypt::Password.new(user['password']) == password
      puts "Login successful! Welcome, #{user['first_name']}!"
      current_user = user

      admin_menu if current_user['admin']
      main_menu if not current_user['admin']
    else
      puts "Invalid username or password. Please try again."
    end
  end

  def register_user
    puts "Register"
    puts "-----------------------------------------"
    username, password, first_name, last_name = nil

    loop do
      print("Enter username : ")
      username = gets.chomp.strip
      if username.empty?
        puts "Username cannot be left empty. Please try again."
      elsif user_controller.get_user_by_username(username)
        puts "Username '#{username}' already exists. Please choose a different username."
      else
        break
      end
    end

    loop do
      print("Enter password : ")
      password = gets.chomp.strip
      break unless password.empty?
      puts "Password cannot be left empty. Please try again."
    end

    loop do
      print("Enter first name : ")
      first_name = gets.chomp.strip
      break unless first_name.empty?
      puts "First name cannot be left empty. Please try again."
    end

    print("Enter last name (press enter to skip) : ")
    last_name = gets.chomp.strip
    last_name = nil if last_name.empty?

    hashed_password = BCrypt::Password.create(password)
    result = user_controller.create_user(username: username,password: hashed_password,first_name: first_name,last_name: last_name)
    puts "\nRegistration successful! Welcome, #{first_name}!"
    current_user = {
      :id => result['id'],
      :username => result['username'],
    }

    # TODO: Implement menu for normal user
    main_menu
  end

  def admin_menu
    display_welcome_message
    choice = 0
    while choice != 5
      puts "Admin Menu"
      puts "1. Add a New Book"
      puts "2. Restock a Book"
      puts "3. Soft Delete a Book"
      puts "4. Show All Books"
      puts "5. Logout"
      puts "6. Exit"
      print "Enter your choice: "

      choice = gets.chomp.to_i

      display_welcome_message
      case choice
      when 1
        add_new_book
      when 2
        restock_book
      when 3
        soft_delete_book
      when 4
        #TODO: show all available books
      when 5
        @current_user = nil
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
end
