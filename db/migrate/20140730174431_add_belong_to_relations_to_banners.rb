class AddBelongToRelationsToBanners < ActiveRecord::Migration
  def change
    change_table :banners do |t|
      t.belongs_to :shop
      #t.belongs_to :image
      #t.timestamps
    end
  end
end
