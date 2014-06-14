class CreateContactItems < ActiveRecord::Migration
  def change
    create_table :contact_items do |t|
      t.string :name
      t.string :value
      t.belongs_to :contact_type, index: true
      t.belongs_to :shop, index: true

      t.timestamps
    end
  end
end
