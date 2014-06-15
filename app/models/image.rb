class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true

  #has_attached_file :path, :styles => { :large => "800x800", :medium => "400x400>", :small => "200x200>" }
  #attr_accessible :path, :urls
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" } #, :default_url => "/images/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
