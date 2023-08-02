class BookController < DatabaseConnector
  attr_accessor :db

  def initialize
    self.db = DatabaseConnector.conn
  end
end
