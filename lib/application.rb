class Application
  attr_accessor :current_user, :user_controller, :admin_screen

  def initialize(connection)
    self.current_user = nil
    self.user_controller = UserController.new(connection)
    self.admin_screen = AdminScreen.new(connection)
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

    user = user_controller.find_by_username(username)

    if user && BCrypt::Password.new(user['password']) == password
      puts "Login successful! Welcome, #{user['first_name']}!"
      current_user = user

      admin_screen.admin_menu(current_user) if current_user['admin']
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
      elsif user_controller.find_by_username(username)
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
    result = user_controller.create(username: username, password: hashed_password, first_name: first_name, last_name: last_name)
    puts "\nRegistration successful! Welcome, #{first_name}!"
    current_user = {
      :id => result['id'],
      :username => result['username'],
    }

    # TODO: Implement menu for normal user
    main_menu
  end
end
