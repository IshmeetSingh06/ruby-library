class BookController
  attr_accessor :db

  def initialize(connection)
    self.db = connection
  end
end
