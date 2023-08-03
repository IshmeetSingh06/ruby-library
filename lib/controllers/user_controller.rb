class UserController
  def self.find_by_username(username)
    User.find_by_username(username)
  end

  def self.create(user_data)
    # doubt here
    user = User.new(user_data)
    user.save
    user
  end
end
