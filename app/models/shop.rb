class Shop < ActiveRecord::Base
  #has_many :category_shops
  #has_many :categories, :through => :category_shops
  has_and_belongs_to_many :categories # should use has_many :through if you need validations, callbacks, or extra attributes on the join model.
  belongs_to :parent, class_name: "Shop"
  accepts_nested_attributes_for :categories, :allow_destroy => false

  has_many :contact_items
  accepts_nested_attributes_for :contact_items, :allow_destroy => true

  has_many :images, as: :imageable
  accepts_nested_attributes_for :images, :allow_destroy => true

end
