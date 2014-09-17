# This migration comes from activeadmin_seo (originally 20130205160051)
class AddOgsitenameToSeo < ActiveRecord::Migration
  def change
  	add_column :active_admin_seo_meta, :og_site_name, :string
  end
end
