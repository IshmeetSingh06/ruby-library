class UserController
  def find_by_username(username)
    User.find_by_username(username)
  end

  def create(user_data)
    User.new(user_data).save
  end
end
