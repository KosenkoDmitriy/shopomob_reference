class CreateCategoryShops < ActiveRecord::Migration
  def change
    create_table :category_shops do |t|
      t.belongs_to :category
      t.belongs_to :shop

      t.timestamps
    end
  end
end
