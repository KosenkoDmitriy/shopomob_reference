class CreateSeos < ActiveRecord::Migration
  def change
    create_table :seos do |t|
      t.string :title
      t.string :keywords
      t.text :description

      t.timestamps
    end
  end
end
