class AddRelationToStock < ActiveRecord::Migration[6.0]
  def change
    change_table :stocks do |t|
      t.belongs_to :user
    end
  end
end
