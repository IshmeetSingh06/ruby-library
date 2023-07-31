class User
  attr_reader :id
  attr_accessor :username, :password, :first_name, :last_name, :admin

  def initialize(username, password, first_name, last_name = nil, admin = false)
    @username= username
    @password= password
    @first_name= first_name
    @last_name= last_name.empty? ? nil : last_name # Last name can be left epmty
    @admin = admin 
  end
end
