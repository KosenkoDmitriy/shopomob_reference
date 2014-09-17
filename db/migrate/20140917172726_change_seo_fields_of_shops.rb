class ChangeSeoFieldsOfShops < ActiveRecord::Migration
  def change
    change_table :seos do |t|
      t.rename :title, :seo_title
      t.rename :keywords, :seo_keywords
      t.rename :description, :seo_description
    end
  end
end
