class Product < ActiveRecord::Base
  has_and_belongs_to_many :brands
  accepts_nested_attributes_for :brands
end
