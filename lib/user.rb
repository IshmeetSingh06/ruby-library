class User
  attr_reader :id
  attr_accessor :username, :password, :first_name, :last_name, :admin

  def initialize(username, password, first_name, last_name = nil, admin = false)
    self.username= username
    self.password= password
    self.first_name= first_name
    self.last_name= last_name unless last_name.nil? || last_name.empty?
    self.admin = admin
  end
end
