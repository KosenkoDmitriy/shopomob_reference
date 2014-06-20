class AddTagsToShop < ActiveRecord::Migration
  def change
    add_column :shops, :tags, :string
  end
end
