class AddImageToBannersAndServices < ActiveRecord::Migration
  def change
    add_attachment :banners, :image
    add_attachment :services, :image
  end
end
