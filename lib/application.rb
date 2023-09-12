class Application
  attr_accessor :current_user, :admin_screen

  def initialize
    self.current_user = nil
    self.admin_screen = AdminScreen.new
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

  private
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

  private
  def login_user
    puts "Login"
    puts "-----------------------------------------"
    username = UserHelper.parse_username_login
    password = UserHelper.parse_password
    user = UserController.find_by_username(username)
    if user && user.valid_password?(password)
      puts "Login successful! Welcome, #{user.first_name}!"
      current_user = user
      if current_user.admin
        admin_screen.admin_menu(current_user)
      else
        main_menu
      end
    else
      puts "Invalid username or password. Please try again."
    end
  end

  private
  def register_user
    puts "Register"
    puts "-----------------------------------------"
    username = UserHelper.parse_username
    password = UserHelper.parse_password
    first_name = UserHelper.parse_first_name
    last_name = UserHelper.parse_last_name
    result = UserController.create(username: username, password: password, first_name: first_name, last_name: last_name)
    if result
      puts "\nRegistration successful! Welcome, #{first_name}!"
      current_user = {
        id: result['id'],
        username: result['username'],
      }
    end
    # TODO: Implement menu for normal user
    main_menu
  end
end
