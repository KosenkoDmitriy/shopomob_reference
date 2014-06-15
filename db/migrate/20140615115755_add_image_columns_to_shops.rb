class AddImageColumnsToShops < ActiveRecord::Migration
  def change
    add_attachment :shops, :image
    add_attachment :contact_types, :image
    add_attachment :category_items, :image
    add_attachment :categories, :image
  end
end
