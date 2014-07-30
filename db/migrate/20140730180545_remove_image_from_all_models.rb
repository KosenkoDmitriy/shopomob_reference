class RemoveImageFromAllModels < ActiveRecord::Migration
  def change
    remove_attachment :banners, :image
    remove_attachment :shops, :image
    remove_attachment :contact_types, :image
    remove_attachment :category_items, :image
    remove_attachment :categories, :image
  end
end
