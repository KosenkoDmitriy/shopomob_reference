class CategoryShop < ActiveRecord::Base
  belongs_to :shop
  belongs_to :category
end
