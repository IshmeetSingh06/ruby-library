class Book
  attr_reader :id
  attr_accessor :title, :genre, :author, :publish_date, :count

  def initialize(title, genre, author, publish_date, count)
    self.title = title
    self.genre = genre
    self.author = author
    self.publish_date = publish_date
    self.count = count
  end
end