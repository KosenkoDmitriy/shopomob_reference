class CategoriesShop < ActiveRecord::Base
  belongs_to :category
  belongs_to :shop
end
