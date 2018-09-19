class User < ApplicationRecord
    validates :username, presence: true, uniqueness: true
    validates :password, length: {minimum: 6}
    has_secure_password

    # has many books and in the books table this user is referenced by owner_id
    has_many :books, foreign_key: "owner_id", inverse_of: 'owner'
    has_many :loans, foreign_key: "borrower_id", inverse_of: "borrower"
    #has_many :borrowed_books, class_name: "Book", foreign_key: "borrower_id", inverse_of: "borrower"
end
