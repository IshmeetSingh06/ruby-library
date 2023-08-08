require_relative '../spec_helper.rb'

describe BookController do
  before(:each) do
    DatabaseConnector.clear_tables
  end

  it 'creates a new book' do
    book_data = {
      title: 'book1',
      genre: 'Fiction',
      author: 'John Doe',
      publish_date: Date.parse('2023-01-01'),
      count: 10
    }
    book = BookController.create(book_data)
    expect(book).to be_instance_of(Book)
    expect(book.title).to eq('book1')
    expect(book.genre).to eq('Fiction')
  end

  it 'finds a book by ID' do
    book_data = {
      title: 'lele',
      genre: 'Mystery',
      author: 'Jhuihuih',
      publish_date: Date.parse('2022-05-15'),
      count: 5
    }
    book = BookController.create(book_data)
    found_book = BookController.find_by_id(book.id)
    expect(found_book).to be_instance_of(Book)
    expect(found_book.author).to eq('Jhuihuih')
  end

  it 'lists available books' do
    book_data = {
      title: 'Avdasdasd',
      genre: 'Adventure',
      author: 'James Johnson',
      publish_date: Date.parse('2021-10-20'),
      count: 3
    }
    BookController.create(book_data)
    available_books = BookController.list_available
    expect(available_books.length).to eq(1)
    expect(available_books.first.genre).to eq('Adventure')
  end

  it 'lists all inventory' do
    book_data = {
      title: 'lol',
      genre: 'Science Fiction',
      author: 'lol',
      publish_date: Date.parse('2020-03-10'),
      count: 7
    }
    BookController.create(book_data)
    inventory = BookController.list_inventory
    expect(inventory.length).to eq(1)
  end

  it 'restocks a book' do
    book_data = {
      title: 'Restock Book',
      genre: 'Fantasy',
      author: 'ish',
      publish_date: Date.parse('2019-08-05'),
      count: 2
    }
    book = BookController.create(book_data)
    BookController.restock(book, 7)
    restocked_book = BookController.find_by_id(book.id)
    expect(restocked_book.count.to_i).to eq(7)
  end

  it 'soft deletes a book' do
    book_data = {
      title: 'Delete',
      genre: 'Horror',
      author: 'Black',
      publish_date: Date.parse('2018-11-25'),
      count: 1
    }
    book = BookController.create(book_data)
    BookController.soft_delete(book)
    deleted_book = BookController.find_by_id(book.id)
    expect(deleted_book).to be_nil
  end
end
