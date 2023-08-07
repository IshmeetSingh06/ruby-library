require_relative '../spec_helper.rb'

describe User do
  let(:user_data) {
    {
      id: 1,
      username: 'admin@library',
      password: '$2a$12$8mhD8508BovQ.mk4R5IKu.0NZ0Dx9STA.gdNvi7gcP1xQ68Rrobg.',
      first_name: 'admin',
      admin: 't',
    }
  }

  describe '#admin?' do
    it 'returns true for an admin user' do
      user = User.new(user_data)
      expect(user.admin?).to be true
    end

    it 'returns false for a non-admin user' do
      user = User.new(user_data)
      expect(user.admin?).to be false
    end
  end

  describe '#valid_password?' do
    let(:user) { User.new(user_data) }

    it 'returns true for a correct password' do
      expect(user.valid_password?('admin@123')).to be true
    end

    it 'returns false for an incorrect password' do
      expect(user.valid_password?('wrong_password')).to be false
    end
  end

  describe '.find_by_username' do
    it 'returns a user for an existing username' do
      found_user = User.find_by_username(user_data[:username])
      expect(found_user).to_not be_nil
      expect(found_user.username).to eq(user_data[:username])
    end

    it 'returns nil for a non-existing username' do
      found_user = User.find_by_username('non_existing_username')
      expect(found_user).to be_nil
    end
  end
end
