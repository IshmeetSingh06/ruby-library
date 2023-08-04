class DatabaseConnector
  def self.connection
    @@connection
  end

  def self.connect
    begin
      @@connection ||= PG.connect(
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

  private
  def self.initialize_tables
    connection.exec(
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
    connection.exec(
      <<~SQL
        CREATE TABLE IF NOT EXISTS books (
          id SERIAL PRIMARY KEY,
          title VARCHAR NOT NULL,
          genre VARCHAR NOT NULL,
          author VARCHAR NOT NULL,
          publish_date DATE,
          count INTEGER NOT NULL,
          deleted BOOLEAN DEFAULT false
        );
      SQL
    )
    connection.exec(
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

  private
  def self.initialize_admin_account
    return if admin_account_exists?

    UserController.create(
      username: ENV['LIBRARY_ADMIN_USERNAME'],
      password: ENV['LIBRARY_ADMIN_PASSWORD'],
      first_name: 'admin',
      admin: true
    )
  end

  private
  def self.admin_account_exists?
    result = UserController.find_by_username(ENV['LIBRARY_ADMIN_USERNAME'])
  end
end
