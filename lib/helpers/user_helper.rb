class UserHelper
  def self.parseUsername
    username = nil;
    loop do
      print("Enter username : ")
      username = gets.chomp.strip
      if username.empty?
        puts "Username cannot be left empty. Please try again."
      elsif UserController.find_by_username(username)
        puts "Username '#{username}' already exists. Please choose a different username."
      else
        break
      end
    end
    username
  end

  def self.parsePassword
    password = nil
    loop do
      print("Enter password : ")
      password = gets.chomp.strip
      break unless password.empty?
      puts "Password cannot be left empty. Please try again."
    end
    password
  end

  def self.parseFirstname
    first_name = nil
    loop do
      print("Enter first name : ")
      first_name = gets.chomp.strip
      break unless first_name.empty?
      puts "First name cannot be left empty. Please try again."
    end
    first_name
  end

  def self.parseLastname
    print("Enter last name (press enter to skip) : ")
    last_name = gets.chomp.strip
    last_name
  end
end
