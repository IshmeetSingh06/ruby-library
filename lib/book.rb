class Book
  attr_reader :id
  attr_accessor :title, :genre, :author, :publish_date, :count

  def initialize(title, genre, author, publish_date, count)
    @title = title
    @genre = genre
    @author = author
    @publish_date = publish_date
    @count = count
  end
end