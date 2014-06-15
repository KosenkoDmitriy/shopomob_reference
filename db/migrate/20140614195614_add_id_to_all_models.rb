class AddIdToAllModels < ActiveRecord::Migration
  def change
    add_column :shops, :_id, :integer
    add_column :categories, :_id, :integer
    add_column :category_items, :_id, :integer
  end
end
