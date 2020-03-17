class AddFieldsToStock < ActiveRecord::Migration[6.0]
  def change
    change_table :stocks do |t|
      t.string :company_name
      t.string :exchange
      t.string :sector
      t.string :website
    end
  end
end
