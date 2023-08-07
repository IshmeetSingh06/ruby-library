# Library Management System

The Library Management System is a command-line application that allows users to manage books, borrow and return books, and perform various administrative tasks related to the library.

## Installation

Follow these steps to set up the Library Management System on your local machine:

1. Clone the repository:
- git clone https://github.com/IshmeetSingh06/ruby-library.git
- cd ruby-library

2. Install dependencies:
- bundle install

4. Configure environment variables:
- Create a `.env` file in the project root directory.
- Add the necessary environment variables for your database configuration. For example:
  ```
  DATABASE_USERNAME=your_database_username
  DATABASE_PASSWORD=your_database_password
  DATABASE_PORT=your_database_port
  LIBRARY_ADMIN_USERNAME=library_admin_username
  LIBRARY_ADMIN_PASSWROD=library_admin_password
  ```

5. Run the application:
- ruby boot.rb


## Usage

Upon running the application, you will be presented with a login screen. Use your username and password to log in as a user or admin.

### User Features

- View available books in the library.
- Borrow books from the library.
- Return books to the library.
- View a list of books currently borrowed.

### Admin Features

- Add new books to the library inventory.
- Restock books with additional copies.
- Soft delete books from the inventory (mark as unavailable).
- View all books in the library inventory.

## Tests and Code Coverage

To run the test suite and check code coverage, run the following command:
- bundle exec rspec --format documentation

The test results and code coverage report will be available in the `coverage` directory.

## Dependencies

- Ruby
- PostgreSQL
- Bundler
- RSpec
- SimpleCov
- pg (PostgreSQL gem)
- dotenv (gem for managing environment variables)

## Contributing

Contributions to the Library Management System are welcome! If you find any issues or have suggestions for improvements, please feel free to submit a pull request.

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.

