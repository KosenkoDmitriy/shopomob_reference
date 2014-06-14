class ContactItem < ActiveRecord::Base
  belongs_to :shop
  belongs_to :contact_type
end
