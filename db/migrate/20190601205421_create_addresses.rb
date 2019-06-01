class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.string :address_line
      t.string :city
      t.string :state
      t.string :zip
      t.string :nickname
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
