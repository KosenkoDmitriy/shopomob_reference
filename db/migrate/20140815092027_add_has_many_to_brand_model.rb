class AddHasManyToBrandModel < ActiveRecord::Migration
  def change
    create_table :brands_products, id: false do |t|
      t.belongs_to :brand, index: true
      t.belongs_to :product, index: true
    end
  end
end
