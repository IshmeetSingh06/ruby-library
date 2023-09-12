require_relative '../spec_helper.rb'

describe Book do
  before(:each) do
    DatabaseConnector.clear_tables
  end

  describe '.list_available' do
    it 'returns available books in the inventory' do
      book = Book.new(
        title: 'First',
        genre: 'fantasy',
        author: 'ishmeet',
        publish_date: '2000-09-06',
        count: 20
      )
      book = book.save
      available_books = Book.list_available
      expect(available_books).to_not be_empty
      expect(available_books.first.title).to eq(book.title)
    end

    it 'returns an empty array if no books are available' do
      available_books = Book.list_available
      expect(available_books).to be_empty
    end
  end

  describe '.find_by_id' do
    it 'returns a book for an existing ID' do
      book = Book.new(
        title: 'First',
        genre: 'fantasy',
        author: 'ishmeet',
        publish_date: '2000-09-06',
        count: 20
      )
      book = book.save
      found_book = Book.find_by_id(book.id)
      expect(found_book).to_not be_nil
      expect(found_book.title).to eq(book.title)
    end

    it 'returns nil for a non-existing ID' do
      found_book = Book.find_by_id(999)
      expect(found_book).to be_nil
    end
  end

  describe '.list_inventory' do
    it 'returns all books in the inventory' do
      book = Book.new(
        title: 'First',
        genre: 'fantasy',
        author: 'ishmeet',
        publish_date: '2000-09-06',
        count: 10
      )
      book = book.save
      all_books = Book.list_inventory
      expect(all_books).to_not be_empty
      expect(all_books.first.title).to eq(book.title)
    end

    it 'returns an empty array if no books are in the inventory' do
      all_books = Book.list_inventory
      expect(all_books).to be_empty
    end
  end

  describe '#save' do
    it 'creates a new book and saves to the database' do
      book = Book.new(
        title: 'First',
        genre: 'fantasy',
        author: 'ishmeet',
        publish_date: '2000-09-06',
        count: 20
      )
      book = book.save
      expect { book.save }.to change { Book.find_by_id(book.id) }
    end

    it 'updates an existing book and saves to the database' do
      book = Book.new(
        title: 'First',
        genre: 'fantasy',
        author: 'ishmeet',
        publish_date: '2000-09-06',
        count: 20
      )
      book = book.save
      book.genre = 'new-genre'
      expect { book.save }.to change { Book.find_by_id(book.id) }
      expect(Book.find_by_id(book.id).genre).to eq('new-genre')
    end
  end

  describe '#delete' do
    it 'soft deletes a book from the database' do
      book = Book.new(
        title: 'First',
        genre: 'fantasy',
        author: 'ishmeet',
        publish_date: '2000-09-06',
        count: 20
      )
      book = book.save
      expect { book.delete }.to change { Book.find_by_id(book.id) }
      expect(Book.find_by_id(book.id)).to be_nil
    end
  end
end
