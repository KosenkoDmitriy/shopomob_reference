class AddCommentsToShopModel < ActiveRecord::Migration
  def change
    add_column :shops, :comments, :text
  end
end
