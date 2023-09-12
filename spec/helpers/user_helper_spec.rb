require_relative '../spec_helper.rb'

describe UserHelper do
  before(:each) do
    DatabaseConnector.clear_tables
  end

  describe '.parse_username' do
    it 'returns a valid username if user does not exist' do
      allow(UserHelper).to receive(:gets).and_return("new_username\n")
      expect(UserHelper.parse_username).to eq('new_username')
    end
  end

  describe '.parse_username_login' do
    it 'returns a valid username if user does not exist' do
      allow(UserHelper).to receive(:gets).and_return("hi_username\n")
      expect(UserHelper.parse_username_login).to eq('hi_username')
    end
  end

  describe '.parse_password' do
    it 'returns a valid password' do
      allow(UserHelper).to receive(:gets).and_return("secure_password\n")
      expect(UserHelper.parse_password).to eq('secure_password')
    end
  end

  describe '.parse_password' do
    it 'returns a valid password' do
      allow(UserHelper).to receive(:gets).and_return("secure_password\n")
      expect(UserHelper.parse_password).to eq('secure_password')
    end
  end

  describe '.parse_first_name' do
    it 'returns a valid first name' do
      allow(UserHelper).to receive(:gets).and_return("John\n")
      expect(UserHelper.parse_first_name).to eq('John')
    end
  end

  describe '.parse_last_name' do
    it 'returns a valid last name' do
      allow(UserHelper).to receive(:gets).and_return("Doe\n")
      expect(UserHelper.parse_last_name).to eq('Doe')
    end
  end
end
