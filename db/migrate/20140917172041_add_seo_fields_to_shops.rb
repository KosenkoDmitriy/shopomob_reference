class AddSeoFieldsToShops < ActiveRecord::Migration
  def change
    change_table :shops do |t|
      t.references :seo
    end
    add_index :shops, :seo_id
  end
end
