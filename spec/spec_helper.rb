require 'simplecov'
SimpleCov.start do
  add_filter 'spec/'
end

require 'rspec'
require 'pg'
require 'bcrypt'
require 'dotenv/load'
require_relative '../lib/database_connector'
require_relative '../lib/entities/base_entity'
require_relative '../lib/entities/user'
require_relative '../lib/entities/book'
require_relative '../lib/entities/borrow_log'
require_relative '../lib/controllers/user_controller'
require_relative '../lib/controllers/book_controller'
require_relative '../lib/controllers/borrow_log_controller'
require_relative '../lib/screens/user_screen'
require_relative '../lib/screens/admin_screen'
require_relative '../lib/helpers/user_helper'
require_relative '../lib/helpers/book_helper'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseConnector.connect
  end
end

