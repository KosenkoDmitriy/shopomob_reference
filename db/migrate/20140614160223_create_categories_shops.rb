class CreateCategoriesShops < ActiveRecord::Migration
  def change
    create_table :categories_shops, id: false do |t|
      t.belongs_to :category
      t.belongs_to :shop
    end
  end
end
