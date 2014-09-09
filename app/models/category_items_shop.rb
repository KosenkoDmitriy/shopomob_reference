class CategoryItemsShop < ActiveRecord::Base
  belongs_to :shop
  belongs_to :category_item
  #validates_uniqueness_of :shop_id, :scope => [:category_item_id]
end
