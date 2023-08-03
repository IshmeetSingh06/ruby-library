class User < BaseEntity
  attr_reader :id
  attr_accessor :username, :password, :first_name, :last_name, :admin

  def initialize(user_data)
    self.username = user_data[:username]
    self.password = user_data[:password]
    self.first_name = user_data[:first_name]
    self.last_name = user_data[:last_name]
    self.admin = user_data[:admin] || false
  end

  def save
    begin
      @@db.exec_params('INSERT INTO users (username, password, first_name, last_name, admin) VALUES ($1, $2, $3, $4, $5) RETURNING *;', [username, password, first_name, last_name, false]).first
    rescue PG::Error => error
      puts "Error occurred while creating user: #{error.message}"
    end
  end

  def self.find_by_username(username)
    begin
      result = db.exec_params('SELECT * FROM users WHERE username = $1', [username]).first
      if result
        User.new(username: result['username'], password: result['password'], first_name: result['first_name'], last_name: result['last_name'], admin: result['admin'])
      end
    rescue PG::Error => error
      puts "Error occurred while fetching user by username: #{error.message}"
    end
  end
end
