class Category < ActiveRecord::Base
  #has_many :category_shops
  #has_many :shops, :through => :category_shops
  has_and_belongs_to_many :shops

end
