class BaseEntity
  @@db = nil

  def self.db
    @@db ||= DatabaseConnector.connection
  end
end
