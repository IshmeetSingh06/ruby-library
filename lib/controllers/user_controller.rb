class UserController < DatabaseConnector
  attr_accessor :db

  def initialize
    self.db = DatabaseConnector.conn
  end

  def get_user_by_username(username)
    begin
      result = db.exec_params('SELECT * FROM users WHERE username = $1', [username])
      result.first
    rescue PG::Error => error
      puts "Error occurred while fetching user by username: #{error.message}"
    end
  end

  def create_user(user_data)
    begin
      result = db.exec_params('INSERT INTO users (username, password, first_name, last_name, admin) VALUES ($1, $2, $3, $4, $5) RETURNING *;', [user_data[:username], user_data[:password], user_data[:first_name], user_data[:last_name], false])
      result.first
    rescue PG::Error => error
      puts "Error occurred while creating user: #{error.message}"
      nil
    end
  end
end
