class Application
  attr_accessor :current_user, :admin_screen, :user_screen

  def initialize
    self.current_user = nil
    self.admin_screen = AdminScreen.new
    self.user_screen = UserScreen.new
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

  def login_user
    puts "Login"
    puts "-----------------------------------------"
    print "Enter username : "
    username = gets.chomp
    print "Enter password : "
    password = gets.chomp

    user = UserController.find_by_username(username)
    if user && BCrypt::Password.new(user.password) == password
      puts "Login successful! Welcome, #{user.first_name}!"
      current_user = user
      if current_user.admin == 't'
        admin_screen.admin_menu(current_user)
      else
        user_screen.main_menu(current_user)
      end
    else
      puts "Invalid username or password. Please try again."
    end
  end

  def register_user
    puts "Register"
    puts "-----------------------------------------"
    username = UserHelper.parseUsername
    password = UserHelper.parsePassword
    first_name = UserHelper.parseFirstname
    last_name = UserHelper.parseLastname
    hashed_password = BCrypt::Password.create(password)

    result = UserController.create(username: username, password: hashed_password, first_name: first_name, last_name: last_name)
    if !result.nil?
      puts "\nRegistration successful! Welcome, #{first_name}!"
      current_user = result
      user_screen.main_menu(current_user)
    else
      puts "Registration failed, exiting the program"
      exit(1)
    end
  end
end
