class Category < ActiveRecord::Base
  #has_many :category_shops
  #has_many :shops, :through => :category_shops
  has_and_belongs_to_many :shops #should use has_many :through if you need validations, callbacks, or extra attributes on the join model.
  accepts_nested_attributes_for :shops, :allow_destroy => false

  belongs_to :parent, class_name: "Category"
  has_and_belongs_to_many :category_items # should use has_many :through if you need validations, callbacks, or extra attributes on the join model.

  has_one :image, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :image, :allow_destroy => true

end
