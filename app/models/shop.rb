class Shop < ActiveRecord::Base
  #has_many :category_shops
  #has_many :categories, :through => :category_shops
  has_and_belongs_to_many :categories # should use has_many :through if you need validations, callbacks, or extra attributes on the join model.
  belongs_to :parent, class_name: "Shop"
  has_many :contact_items
end
