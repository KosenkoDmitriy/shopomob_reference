class Image < ActiveRecord::Base
  belongs_to :imageable, polymorphic: true

  #has_attached_file :path, :styles => { :large => "800x800", :medium => "400x400>", :small => "200x200>" }
  #attr_accessible :path, :urls
  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/assets/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  def image_url_thumb
    image.url(:thumb)
  end
  def image_url
    image.url(:medium)
  end
  def image_url_original
    image.url(:original)
  end

  def url_thumb
    image.url(:thumb)
  end
  def url
    image.url(:medium)
  end
  def url_original
    image.url(:original)
  end

end
