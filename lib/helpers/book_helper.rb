class BookHelper
  def self.parse_title
    title = nil
    loop do
      print("Enter title : ")
      title = gets.chomp.strip
      break unless title.empty?
      puts "Title cannot be left empty. Please try again."
    end
    title
  end

  def self.parse_genre
    genre = nil
    loop do
      print("Enter genre : ")
      genre = gets.chomp.strip
      break unless genre.empty?
      puts "Genre cannot be left empty. Please try again."
    end
    genre
  end

  def self.parse_author
    author = nil
    loop do
      print("Enter author : ")
      author = gets.chomp.strip
      break unless author.empty?
      puts "Author cannot be left empty. Please try again."
    end
    author
  end

  def self.parse_publish_date
    publish_date = nil
    loop do
      print("Enter publish date (dd/mm/yyy) : ")
      publish_date_input = gets.chomp.strip
      begin
        publish_date = Date.parse(publish_date_input)
        break
      rescue Date::Error => exception
        puts "Date invalid or empty please try again"
      end
    end
    publish_date
  end

  def self.parse_count
    count = 0
    loop do
      print("Enter count : ")
      count = gets.chomp.to_i
      break unless count <= 0
      puts "Count invalid or empty. Please try again."
    end
    count
  end

  def self.parse_book_id(prompt)
    book_id = 0
    loop do
      print("Enter the id of the book you want to #{prompt} : ")
      book_id = gets.chomp.to_i
      break unless book_id < 0
      puts "Id invalid or empty. Please try again."
    end
    book_id
  end
end
