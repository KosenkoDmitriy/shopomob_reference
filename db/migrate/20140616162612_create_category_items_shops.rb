class CreateCategoryItemsShops < ActiveRecord::Migration
  def change
    create_table :category_items_shops do |t|
      t.belongs_to :shop
      t.belongs_to :category_item
      t.timestamps
    end
  end
end
