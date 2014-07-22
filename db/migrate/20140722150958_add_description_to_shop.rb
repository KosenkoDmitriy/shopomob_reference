class AddDescriptionToShop < ActiveRecord::Migration
  def change
    add_column :shops, :description, :text
  end
end
