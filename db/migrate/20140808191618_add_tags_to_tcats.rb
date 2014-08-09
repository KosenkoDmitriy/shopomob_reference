class AddTagsToTcats < ActiveRecord::Migration
  def change
    add_column :category_items, :tags, :string
    add_column :categories, :tags, :string
  end
end
