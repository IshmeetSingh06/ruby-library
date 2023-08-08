require_relative '../spec_helper.rb'

describe UserHelper do
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
