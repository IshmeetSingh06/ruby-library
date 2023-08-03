require_relative 'lib/application.rb'
require_relative 'lib/database_connector.rb'
require_relative 'lib/entities/base_entity.rb'
require_relative 'lib/entities/user.rb'
require_relative 'lib/entities/book.rb'
require_relative 'lib/entities/borrow_log.rb'
require_relative 'lib/controllers/user_controller.rb'
require_relative 'lib/controllers/book_controller.rb'
require_relative 'lib/screens/admin_screen.rb'
require 'dotenv/load'
require 'pg'
require 'date'
require 'bcrypt'

DatabaseConnector.connect
app = Application.new

app.start
