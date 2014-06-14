class AddParentIdToShop < ActiveRecord::Migration
  def change
    add_reference :shops, :parent, index: true
  end
end
