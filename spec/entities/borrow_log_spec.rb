require_relative '../spec_helper.rb'

describe BorrowLog do
  before(:each) do
    DatabaseConnector.clear_tables
    @book = Book.new(
      title: 'First',
      genre: 'fantasy',
      author: 'ishmeet',
      publish_date: '2000-09-06',
      count: 20
    ).save
    @user = User.new(
      username: 'hello',
      password: 'hello',
      first_name: 'hello',
      admin: false,
    ).save
  end

  describe '#save' do
    it 'creates a new borrow log and saves to the database' do
      log = BorrowLog.new(
        user_id: @user.id,
        book_id: @book.id,
        borrow_time: '2023-07-28',
        return_time: nil
      )
      expect { log.save }.to change { BorrowLog.find_by_id(log.user_id, log.book_id) }
    end

    it 'updates an existing borrow log and saves to the database' do
      log = BorrowLog.new(
        user_id: @user.id,
        book_id: @book.id,
        borrow_time: '2023-07-28',
        return_time: nil
      )
      log = log.save
      log.return_time = '2023-09-30'
      expect { log.save }.to change { BorrowLog.find_by_id(log.user_id, log.book_id) }
      expect(BorrowLog.find_by_id(log.user_id, log.book_id).return_time).to eq('2023-09-30')
    end
  end

  describe '.find_by_id' do
    it 'returns a borrow log for an existing ID' do
      log = BorrowLog.new(
        user_id: @user.id,
        book_id: @book.id,
        borrow_time: '2023-07-28',
        return_time: nil
      )
      log = log.save
      found_log = BorrowLog.find_by_id(log.user_id, log.book_id)
      expect(found_log).to_not be_nil
      expect(found_log.user_id).to eq(log.user_id)
      expect(found_log.book_id).to eq(log.book_id)
    end

    it 'returns nil for a non-existing ID' do
      found_log = BorrowLog.find_by_id(999,999)
      expect(found_log).to be_nil
    end
  end

  describe '.list_logs' do
    it 'returns all borrow logs for a user' do
      log = BorrowLog.new(
        user_id: @user.id,
        book_id: @book.id,
        borrow_time: '2023-07-28',
        return_time: nil
      )
      log = log.save
      all_logs = BorrowLog.list_logs(log.user_id)
      expect(all_logs).to_not be_empty
      expect(all_logs.first.user_id).to eq(log.user_id)
    end

    it 'returns an empty array if no borrow logs are found for a user' do
      expect(BorrowLog.list_logs(999)).to be_empty
    end
  end
end
