class UserController
  def self.find_by_username(username)
    User.find_by_username(username)
  end

  def self.create(user_data)
    User.new(user_data).save
  end

  def self.update(new_user_data)
    User.new(new_user_data).save
  end
end
