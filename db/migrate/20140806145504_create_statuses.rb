class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.integer :no
      t.string :title
      t.string :text

      t.timestamps
    end
  end
end
