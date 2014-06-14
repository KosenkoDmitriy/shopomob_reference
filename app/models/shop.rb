class Shop < ActiveRecord::Base
  has_many :category_shops
  has_many :categories, :through => :category_shops

  #has_many :shop_emails
  #has_many :emails, :through => :shop_emails
  #
  #has_many :shop_phones
  #has_many :phones, :through => :shop_phones
  #
  #has_many :shop_urls
  #has_many :urls, :through => :shop_urls
end
