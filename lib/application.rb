class LibraryApp
  attr_accessor :db

  def initialize
    self.db = DatabaseConnector.new
  end

  def start
    puts "Welcome to the Library Management System!"
    puts "-----------------------------------------"
  end
end
