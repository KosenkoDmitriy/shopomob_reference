class AddStatusToShop < ActiveRecord::Migration
  def change
    #add_column :shops, :status_id, :integer
    #add_index :shops, :status_id

    change_table :shops do |t|
      t.belongs_to :status
    end
  end
end
