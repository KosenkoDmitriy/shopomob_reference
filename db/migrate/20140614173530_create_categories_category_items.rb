class CreateCategoriesCategoryItems < ActiveRecord::Migration
  def change
    create_table :categories_category_items, id: false do |t|
      t.belongs_to :category
      t.belongs_to :category_item
    end
  end
end
