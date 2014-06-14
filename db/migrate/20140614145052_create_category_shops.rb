class CreateCategoryShops < ActiveRecord::Migration
  def change
    create_table :category_shops do |t|
      t.belongs_to :shop, index: true
      t.belongs_to :category, index: true

      t.timestamps
    end
  end
end
