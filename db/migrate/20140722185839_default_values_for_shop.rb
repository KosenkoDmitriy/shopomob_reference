class DefaultValuesForShop < ActiveRecord::Migration
  def change
    change_column :shops, :rated, :integer, :null => false, :default => 0
    change_column :shops, :favorite, :integer, :null => false, :default => 0
  end
end
