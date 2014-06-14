class CategoryItem < ActiveRecord::Base
  #has_many :subordinates, class_name: "CategoryItem",
  #         foreign_key: "parent_id"

  belongs_to :parent, class_name: "CategoryItem"
end
