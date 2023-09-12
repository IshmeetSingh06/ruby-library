require_relative '../spec_helper.rb'

describe BorrowLogController do
  before(:each) do
    DatabaseConnector.clear_tables
    @user = User.new(
      username: 'testuser',
      password: 'password',
      first_name: 'Test',
      last_name: 'User',
      admin: false
    ).save
    @book = Book.new(
      title: 'Test Book',
      genre: 'Adventure',
      author: 'ish',
      publish_date: Date.parse('2023-01-01'),
      count: 5
    ).save
    @borrow_log = {
      user_id: @user.id,
      book_id: @book.id,
      borrow_time: Time.now.strftime('%Y-%m-%d %H:%M:%S'),
      return_time: nil
    }
  end

  it 'creates a new borrow log' do
    log = BorrowLogController.create(@borrow_log)
    expect(log).to be_instance_of(BorrowLog)
    expect(log.user_id).to eq(@user.id)
  end

  it 'returns a book' do
    log = BorrowLogController.create(@borrow_log)
    BorrowLogController.return(log)
    returned_log = BorrowLogController.find_by_ref_id(log.user_id, log.book_id)
    expect(returned_log.return_time).to_not be_nil
  end

  it 'finds borrowed books for a user' do
    log = BorrowLogController.create(@borrow_log)
    borrowed_books = BorrowLogController.find_borrowed_books(@user.id)
    expect(borrowed_books.length).to eq(1)
    expect(borrowed_books.first.book_id).to eq(@book.id)
  end

  it 'finds a borrow log by reference IDs' do
    log = BorrowLogController.create(@borrow_log)
    found_log = BorrowLogController.find_by_ref_id(@user.id, @book.id)
    expect(found_log).to be_instance_of(BorrowLog)
    expect(found_log.borrow_time).to_not be_nil
  end
end
