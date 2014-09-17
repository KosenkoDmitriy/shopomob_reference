# This migration comes from activeadmin_seo (originally 20130205150736)
class AddDescriptionToOpengraphSeo < ActiveRecord::Migration
  def change
  	add_column :active_admin_seo_meta, :og_description, :string
  end
end
