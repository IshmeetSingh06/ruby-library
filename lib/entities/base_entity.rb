class BaseEntity
  def self.db
    @@db ||= DatabaseConnector.connection
  end
end
