class Shop < ActiveRecord::Base
  belongs_to :parent, class_name: "Shop"

  #has_and_belongs_to_many :categories # should use has_many :through if you need validations, callbacks, or extra attributes on the join model.
  has_many :categories_shops
  has_many :categories, :through => :categories_shops
  accepts_nested_attributes_for :categories, :allow_destroy => true

  has_many :category_items_shops
  has_many :category_items, through: :category_items_shops
  accepts_nested_attributes_for :category_items, :allow_destroy => true

  has_many :contact_items, dependent: :destroy
  accepts_nested_attributes_for :contact_items, :allow_destroy => true

  has_many :images, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :images, :allow_destroy => true

  belongs_to :status

end
