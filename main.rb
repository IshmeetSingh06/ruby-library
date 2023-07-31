require './lib/library_app.rb'
require './lib/library_db.rb'
require 'dotenv/load'
require 'pg'
require 'date'
require 'bcrypt'

app = LibraryApp.new
app.start
