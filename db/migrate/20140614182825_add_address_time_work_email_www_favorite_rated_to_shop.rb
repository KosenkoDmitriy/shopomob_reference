class AddAddressTimeWorkEmailWwwFavoriteRatedToShop < ActiveRecord::Migration
  def change
    add_column :shops, :postal_code, :integer
    add_column :shops, :address, :string
    add_column :shops, :time_work, :string
    add_column :shops, :email, :string
    add_column :shops, :www, :string
    add_column :shops, :favorite, :integer
    add_column :shops, :rated, :integer
  end
end
