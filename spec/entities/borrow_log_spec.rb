require_relative '../spec_helper.rb'

describe BorrowLog do
  let(:log_data) do
    {
      user_id: 12,
      book_id: 4,
      borrow_time: '2023-07-28',
      return_time: nil
    }
  end

  describe '#save' do
    it 'creates a new borrow log and saves to the database' do
      log = BorrowLog.new(log_data)
      expect { log.save }.to change { BorrowLog.find_by_id(log.user_id, log.book_id) }
    end

    it 'updates an existing borrow log and saves to the database' do
      log = BorrowLog.new(log_data)
      updated_log_data = log_data.merge(id: 137, return_time: '2023-07-30')
      updated_log = BorrowLog.new(updated_log_data)
      expect { updated_log.save }.to change { BorrowLog.find_by_id(log.user_id, log.book_id) }
      expect(BorrowLog.find_by_id(log.user_id, log.book_id).return_time).to eq('2023-07-30')
    end
  end

  describe '.find_by_id' do
    it 'returns a borrow log for an existing ID' do
      log = BorrowLog.new(log_data)
      found_log = BorrowLog.find_by_id(log.user_id, log.book_id)
      expect(found_log).to_not be_nil
      expect(found_log.user_id.to_i).to eq(log_data[:user_id])
      expect(found_log.book_id.to_i).to eq(log_data[:book_id])
    end

    it 'returns nil for a non-existing ID' do
      found_log = BorrowLog.find_by_id(999,999)
      expect(found_log).to be_nil
    end
  end

  describe '.list_logs' do
    it 'returns all borrow logs for a user' do
      log = BorrowLog.new(log_data)
      all_logs = BorrowLog.list_logs(log_data[:user_id])
      expect(all_logs).to_not be_empty
      expect(all_logs.first.user_id.to_i).to eq(log_data[:user_id])
    end

    it 'returns an empty array if no borrow logs are found for a user' do
      all_logs = BorrowLog.list_logs(999)
      expect(all_logs).to be_empty
    end
  end
end
