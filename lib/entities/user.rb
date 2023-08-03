class User < BaseEntity
  attr_reader :id
  attr_accessor :username, :password, :first_name, :last_name, :admin

  def initialize(user_data)
    self.id = user_data[:id] || nil
    self.username = user_data[:username]
    self.password = user_data[:password]
    self.first_name = user_data[:first_name]
    self.last_name = user_data[:last_name]
    self.admin = user_data[:admin] || false
  end

  def save
    begin
      result = @@db.exec_params('INSERT INTO users (username, password, first_name, last_name, admin) VALUES ($1, $2, $3, $4, $5) RETURNING *;', [username, password, first_name, last_name, false])
      result.first
    rescue PG::Error => error
      puts "Error occurred while creating user: #{error.message}"
      nil
    end
  end

  def self.find_by_username(username)
    begin
      result = db.exec_params('SELECT * FROM users WHERE username = $1', [username])
      result.first
    rescue PG::Error => error
      puts "Error occurred while fetching user by username: #{error.message}"
    end
  end
end
