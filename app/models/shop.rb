class Shop < ActiveRecord::Base
  belongs_to :parent, class_name: "Shop"

  #has_and_belongs_to_many :categories # should use has_many :through if you need validations, callbacks, or extra attributes on the join model.
  has_many :categories_shops
  has_many :categories, :through => :categories_shops
  accepts_nested_attributes_for :categories, :allow_destroy => true

  has_many :category_items_shops
  has_many :category_items, through: :category_items_shops
  accepts_nested_attributes_for :category_items, :allow_destroy => true
  #attr_accessor :category_items_ids
  #before_save :assign_categories
  #
  #private
  #def assign_categories
  #  category_items_ids.each do |cid|
  #    self.category_items.build(category_item_id: cid )
  #  end
  #end

  has_many :contact_items, dependent: :destroy
  accepts_nested_attributes_for :contact_items, :allow_destroy => true

  has_many :images, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :images, :allow_destroy => true

  belongs_to :status

  #Shop.select(:name,:address).group(:name,:address).having("count(*) > 1").count #search duplicates
  def self.dedupe
    # find all models and group them on keys which should be common
    grouped = all.group_by{|model| [model.name,model.address] }
    grouped.values.each do |duplicates|
      # the first one we want to keep right?
      first_one = duplicates.shift # or pop for last one
      # if there are any more left, they are duplicates
      # so delete all of them
      duplicates.each{|double| double.destroy} # duplicates can now be destroyed
    end
  end
end
