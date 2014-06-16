class CategoryItem < ActiveRecord::Base
  #has_many :subordinates, class_name: "CategoryItem",
  #         foreign_key: "parent_id"
  belongs_to :parent, class_name: "CategoryItem"
  has_and_belongs_to_many :categories

  has_many :category_items_shops
  has_many :shops, through: :category_items_shops
  #has_many :category_shops
  #has_many :shops, :through => :category_shops

  has_one :image, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :image, :allow_destroy => true
end
