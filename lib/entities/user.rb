class User < BaseEntity
  attr_accessor :id, :username, :password, :first_name, :last_name, :admin

  def initialize(user_data)
    self.id = user_data[:id]
    self.username = user_data[:username]
    self.password = user_data[:password]
    self.first_name = user_data[:first_name]
    self.last_name = user_data[:last_name]
    self.admin = user_data[:admin] || false
  end

  def admin?
    admin == 't'
  end

  def valid_password?(password_to_check)
    BCrypt::Password.new(password) == password_to_check
  end

  def save
    begin
      hashed_password = BCrypt::Password.create(password)
      if id.nil?
        BaseEntity.db.exec_params(
          'INSERT INTO users (username, password, first_name, last_name, admin) VALUES ($1, $2, $3, $4, $5);',
          [username, hashed_password, first_name, last_name, false]
        )
      else
        BaseEntity.db.exec_params('UPDATE users SET username = $1, password = $2, first_name = $3, last_name = $4 WHERE id = $5;',
          [username, hashed_password, first_name, last_name, id]
        )
      end
      self
    rescue PG::Error => error
      puts "Error occurred while creating/updating user: #{error.message}"
    end
  end

  def self.find_by_username(username)
    begin
      result = BaseEntity.db.exec_params('SELECT * FROM users WHERE username = $1', [username]).first
      if result
        new(result.transform_keys(&:to_sym))
      end
    rescue PG::Error => error
      puts "Error occurred while fetching user by username: #{error.message}"
    end
  end
end
