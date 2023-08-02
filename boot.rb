require './lib/application.rb'
require './lib/database_connector.rb'
require './lib/entities/user.rb'
require './lib/entities/book.rb'
require './lib/entities/borrow_log.rb'
require 'dotenv/load'
require 'pg'
require 'date'
require 'bcrypt'

app = LibraryApp.new
app.start
