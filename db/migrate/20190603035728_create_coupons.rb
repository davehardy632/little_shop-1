class CreateCoupons < ActiveRecord::Migration[5.1]
  def change
    create_table :coupons do |t|
      t.string :name, unique: true
      t.decimal :discount
      t.boolean :enabled, default: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
