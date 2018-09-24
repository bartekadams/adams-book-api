class AddDataToBooks < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :author, :string
    add_column :books, :genre, :string
    add_column :books, :publication_date, :integer
    add_column :books, :publisher, :string
    add_column :books, :description, :text
  end
end
