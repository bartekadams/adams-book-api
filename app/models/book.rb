class Book < ApplicationRecord
    belongs_to :owner, class_name: "User", foreign_key: 'owner_id'
    has_many :loans

    mount_uploader :book_cover, BookCoverUploader
    serialize :book_cover, JSON # If you use SQLite, add this line.

    validates :name, :author, presence: true
end
