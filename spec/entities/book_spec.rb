require_relative '../spec_helper.rb'

describe Book do
  let(:book_data) {
    {
      id: 4,
      title: 'third',
      genre: 'dsa',
      author: 'sada',
      publish_date: '2000-09-20',
      count: 62
    }
  }

  describe '.list_available' do
    it 'returns available books in the inventory' do
      available_books = Book.list_available
      expect(available_books).to_not be_empty
      expect(available_books.first.title).to eq(book_data[:title])
    end

    it 'returns an empty array if no books are available' do
      available_books = Book.list_available
      expect(available_books).to be_empty
    end
  end

  describe '.find_by_id' do
    it 'returns a book for an existing ID' do
      book = Book.new(book_data)
      book.save
      found_book = Book.find_by_id(book.id)
      expect(found_book).to_not be_nil
      expect(found_book.title).to eq(book_data[:title])
    end

    it 'returns nil for a non-existing ID' do
      found_book = Book.find_by_id(999)
      expect(found_book).to be_nil
    end
  end

  describe '.list_inventory' do
    it 'returns all books in the inventory' do
      all_books = Book.list_inventory
      expect(all_books).to_not be_empty
      expect(all_books.first.title).to eq(book_data[:title])
    end

    it 'returns an empty array if no books are in the inventory' do
      all_books = Book.list_inventory
      expect(all_books).to be_empty
    end
  end

  describe '#save' do
    it 'creates a new book and saves to the database' do
      book = Book.new(book_data)
      expect { book.save }.to change { Book.find_by_id(book.id) }
    end

    it 'updates an existing book and saves to the database' do
      book = Book.new(book_data)
      updated_book_data = book_data.merge(count: 15)
      updated_book = Book.new(updated_book_data)
      expect { updated_book.save }.to change { Book.find_by_id(book.id) }
      expect(Book.find_by_id(book.id).count.to_i).to eq(15)
    end
  end

  describe '#delete' do
    it 'soft deletes a book from the database' do
      book = Book.new(book_data)
      expect { book.delete }.to change { Book.find_by_id(book.id) }
      expect(Book.find_by_id(book.id)).to be_nil
    end
  end
end
