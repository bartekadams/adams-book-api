class Loan < ApplicationRecord
    enum status: { pending: 0, accepted: 1, returned: 2 }
    belongs_to :book
    belongs_to :borrower, class_name: "User", foreign_key: "borrower_id"

    validates :book, :borrower, presence: true
end
