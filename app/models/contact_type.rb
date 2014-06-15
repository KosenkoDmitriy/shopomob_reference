class ContactType < ActiveRecord::Base
  has_one :image, as: :imageable
  accepts_nested_attributes_for :image, :allow_destroy => true
end
