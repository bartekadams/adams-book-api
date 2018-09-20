class User < ApplicationRecord
    validates :username, presence: true, uniqueness: true
    validates :password, length: {minimum: 6}
    has_secure_password

    # has many books and in the books table this user is referenced by owner_id
    has_many :books, foreign_key: "owner_id", inverse_of: 'owner'

    # has many loans as book owner
    has_many :loans_as_owner, through: :books, source: :loans

    # has many borrowers, borrower is user referenced from loans table
    has_many :borrowers, through: :loans_as_owner, source: :borrower

    # has many loans as book borrower
    has_many :loans_as_borrower, class_name: "Loan", foreign_key: "borrower_id", inverse_of: "borrower"

    # has many borrowed books
    has_many :borrowed_books, through: :loans_as_borrower, source: :book
end
