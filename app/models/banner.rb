class Banner < ActiveRecord::Base
  belongs_to :shop

  has_one :image, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :image, :allow_destroy => true
end
