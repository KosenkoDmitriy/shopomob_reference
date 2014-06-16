class CreateCategoriesShops < ActiveRecord::Migration
  def change
    create_table :categories_shops do |t|
      t.belongs_to :category
      t.belongs_to :shop

      t.timestamps
    end
  end
end
