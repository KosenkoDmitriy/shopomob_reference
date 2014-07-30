class DefaultValuesForCatsAndTcats < ActiveRecord::Migration
  def change
    change_column :category_items, :parent_id, :integer, :null => false, :default => 0
    change_column :categories, :parent_id, :integer, :null => false, :default => 0
  end
end
