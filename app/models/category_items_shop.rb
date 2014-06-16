class CategoryItemsShop < ActiveRecord::Base
  belongs_to :shop
  belongs_to :category_item
end
