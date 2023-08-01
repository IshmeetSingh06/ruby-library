class DatabaseConnector
  attr_accessor :conn

  def initialize
    begin
      self.conn = PG.connect(
        dbname: 'postgres',
        user: ENV['DATABASE_USERNAME'],
        password: ENV['DATABASE_PASSWORD'],
        port: ENV['DATABASE_PORT']
      )
    rescue PG::ConnectionBad => error
      puts "An error occurred while connecting to postgres :\n #{error.message}"
      exit(1)
    rescue PG::ServerError => error
      puts "Server Error :\n #{error.message}"
      puts "Exiting the application.................."
      exit(1)
    else
      puts "Successfully connected to postgres"
    ensure
      puts "-----------------------------------------"
    end

    initialize_tables
    initialize_admin_account
  end

  private def initialize_tables
    self.conn.exec(
      <<~SQL
        CREATE TABLE IF NOT EXISTS users (
          id SERIAL PRIMARY KEY,
          username VARCHAR UNIQUE NOT NULL,
          password VARCHAR NOT NULL,
          first_name VARCHAR NOT NULL,
          last_name VARCHAR,
          admin BOOLEAN NOT NULL
        );
      SQL
    )
    self.conn.exec(
      <<~SQL
        CREATE TABLE IF NOT EXISTS books (
          id SERIAL PRIMARY KEY,
          title VARCHAR NOT NULL,
          genre VARCHAR NOT NULL,
          author VARCHAR NOT NULL,
          publish_date DATE NOT NULL,
          count INTEGER NOT NULL
        );
      SQL
    )
    self.conn.exec(
      <<~SQL
        CREATE TABLE IF NOT EXISTS borrow_logs (
          id SERIAL PRIMARY KEY,
          user_id INTEGER REFERENCES users(id),
          book_id INTEGER REFERENCES books(id),
          borrow_time DATE NOT NULL,
          return_time DATE
        );
      SQL
    )
  end

  private def initialize_admin_account
    return if admin_account_exists?

    hashed_password = BCrypt::Password.create(ENV['LIBRARY_ADMIN_PASSWORD'])

    @conn.exec_params(
      'INSERT INTO users (username, password, first_name, admin) VALUES ($1, $2, $3, $4)',
      [ENV['LIBRARY_ADMIN_USERNAME'], hashed_password, 'admin', true]
    )
  end

  private def admin_account_exists?
    result = self.conn.exec_params('SELECT admin FROM users WHERE username = $1',[ENV['LIBRARY_ADMIN_USERNAME']])
    result[0]['admin']
  end
end
