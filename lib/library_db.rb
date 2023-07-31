class LibraryDB
  attr_accessor :conn

  def initialize
     self.conn = PG.connect(
      dbname: 'postgres',
      user: ENV['PG_DATABASE_USERNAME'],
      password: ENV['PG_DATABASE_PASSWORD'],
      port: ENV['PG_DATABASE_PORT']
    )
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

    hashed_password = BCrypt::Password.create('admin@123')

    @conn.exec_params(
      'INSERT INTO users (username, password, first_name, admin) VALUES ($1, $2, $3, $4)',
      ['admin@library', hashed_password, 'admin', true]
    )
  end

  private def admin_account_exists?
    result = self.conn.exec_params('SELECT EXISTS (SELECT 1 FROM users WHERE username = $1)',['admin@library'])
    result[0]['exists'] == 't'
  end
end
