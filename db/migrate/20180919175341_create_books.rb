class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.string :name
      t.references :owner, index: true

      t.timestamps
    end
  end
end
