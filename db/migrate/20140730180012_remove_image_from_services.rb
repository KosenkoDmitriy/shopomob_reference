class RemoveImageFromServices < ActiveRecord::Migration
  def change
    remove_attachment :services, :image
  end
end
