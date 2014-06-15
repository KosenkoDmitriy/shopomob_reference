class ChangeContactItem < ActiveRecord::Migration
  def change
    #add_column :contact_items, :fio, :string
    change_table :contact_items do |t|
      t.column :fio, :string
      t.rename :name, :department
    end
  end
end
