require_relative '../spec_helper.rb'

describe User do
  before(:each) do
    DatabaseConnector.clear_tables
    @user = User.new(
      username: 'hello',
      password: 'hello',
      first_name: 'hello',
      admin: true,
    ).save
  end

  describe '#admin?' do
    it 'returns true for an admin user' do
      expect(@user.admin?).to be true
    end

    it 'returns false for a non-admin user' do
      user = User.new(
        username: 'hello',
        password: 'hello',
        first_name: 'hello',
        admin: false,
      )
      expect(user.admin?).to be false
    end
  end

  describe '#valid_password?' do
    it 'returns true for a correct password' do
      expect(@user.valid_password?('hello')).to be true
    end

    it 'returns false for an incorrect password' do
      expect(@user.valid_password?('wrong_password')).to be false
    end
  end

  describe '#save' do
    it 'creates a new user and saves to the database' do
      user = User.new(
        username: 'hello2',
        password: 'hello',
        first_name: 'hello',
        admin: true,
      )
      expect { user.save }.to change { User.find_by_username(user.username) }
    end

    it 'updates an existing user and saves to the database' do
      @user.last_name = "updates-last-name"
      @user.password = 'new-password'
      @user.admin = true
      expect { @user.save }.to change { User.find_by_username(@user.username) }
      expect(User.find_by_username(@user.username).last_name).to eq('updates-last-name')
    end
  end

  describe '.find_by_username' do
    it 'returns a user for an existing username' do
      found_user = User.find_by_username('hello')
      expect(found_user).to_not be_nil
      expect(found_user.username).to eq('hello')
    end

    it 'returns nil for a non-existing username' do
      found_user = User.find_by_username('non_existing_username')
      expect(found_user).to be_nil
    end
  end
end
