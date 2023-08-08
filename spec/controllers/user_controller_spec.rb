require_relative '../spec_helper.rb'

describe UserController do
  before(:each) do
    DatabaseConnector.clear_tables
  end

  it 'creates a new user' do
    user_data = {
      username: 'testuser',
      password: 'testpass',
      first_name: 'Test',
      last_name: 'User'
    }
    user = UserController.create(user_data)
    expect(user).to be_instance_of(User)
    expect(user.username).to eq('testuser')
    expect(user.first_name).to eq('Test')
  end

  it 'finds a user by username' do
    user_data = {
      username: 'tesdsat',
      password: 'testpass',
      first_name: 'Fi',
      last_name: 'Me'
    }
    UserController.create(user_data)
    found_user = UserController.find_by_username('tesdsat')
    expect(found_user).to be_instance_of(User)
    expect(found_user.first_name).to eq('Fi')
  end

  it 'updates user information' do
    user_data = {
      username: 'updateuser',
      password: 'testpass',
      first_name: 'Update',
      last_name: 'User'
    }
    user = UserController.create(user_data)
    updated_data = {
      id: user.id,
      username: user.username,
      password: 'newpass',
      first_name: 'Updated',
      last_name: 'User'
    }
    updated_user = UserController.update(updated_data)
    expect(updated_user).to be_instance_of(User)
    expect(updated_user.password).to_not eq('testpass')
  end
end
