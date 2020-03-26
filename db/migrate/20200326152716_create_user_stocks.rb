class CreateUserStocks < ActiveRecord::Migration[6.0]
  def change
    create_table :user_stocks do |t|
      t.belongs_to :user
      t.belongs_to :stock
      t.timestamps
    end

    change_table :stocks do |t|
      t.remove :user_id
    end
  end
end
