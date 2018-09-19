class CreateLoans < ActiveRecord::Migration[5.1]
  def change
    create_table :loans do |t|
      t.integer :status, default: 0
      t.references :book, index: true
      t.references :borrower, index: true

      t.timestamps
    end
  end
end
