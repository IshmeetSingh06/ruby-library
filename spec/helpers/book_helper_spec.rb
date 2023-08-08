require_relative '../spec_helper.rb'

describe BookHelper do
  before(:each) do
    DatabaseConnector.clear_tables
  end

  describe '.parse_title' do
    it 'returns a valid title' do
      allow(BookHelper).to receive(:gets).and_return("Book Title\n")
      expect(BookHelper.parse_title).to eq('Book Title')
    end
  end

  describe '.parse_genre' do
    it 'returns a valid genre' do
      allow(BookHelper).to receive(:gets).and_return("Fiction\n")
      expect(BookHelper.parse_genre).to eq('Fiction')
    end
  end

  describe '.parse_author' do
    it 'returns a valid author name' do
      allow(BookHelper).to receive(:gets).and_return("John Doe\n")
      expect(BookHelper.parse_author).to eq('John Doe')
    end
  end

  describe '.parse_publish_date' do
    it 'returns a valid publish date' do
      allow(BookHelper).to receive(:gets).and_return("2023-07-31\n")
      expect(BookHelper.parse_publish_date).to eq(Date.parse("2023-07-31"))
    end

    it 'retries when an invalid date is entered' do
      allow(BookHelper).to receive(:gets).and_return("invalid_date\n", "2023-07-31\n")
      expect(BookHelper.parse_publish_date).to eq(Date.parse("2023-07-31"))
    end
  end

  describe '.parse_count' do
    it 'returns a valid count' do
      allow(BookHelper).to receive(:gets).and_return("5\n")
      expect(BookHelper.parse_count).to eq(5)
    end

    it 'retries when a non-positive count is entered' do
      allow(BookHelper).to receive(:gets).and_return("0\n", "-3\n", "5\n")
      expect(BookHelper.parse_count).to eq(5)
    end
  end

  describe '.parse_book_id' do
    it 'returns a valid book ID' do
      allow(BookHelper).to receive(:gets).and_return("42\n")
      expect(BookHelper.parse_book_id('prompt')).to eq(42)
    end

    it 'retries when an invalid book ID is entered' do
      allow(BookHelper).to receive(:gets).and_return("-1\n", "42\n")
      expect(BookHelper.parse_book_id('prompt')).to eq(42)
    end
  end
end
