class Shop < ActiveRecord::Base
  #has_many :category_shops
  #has_many :categories, :through => :category_shops
  has_and_belongs_to_many :categories

end
