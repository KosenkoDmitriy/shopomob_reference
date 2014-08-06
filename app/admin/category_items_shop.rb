ActiveAdmin.register CategoryItemsShop do
  menu :label => proc{ I18n.t("tcat_shops") } , :parent => I18n.t("cats")

  permit_params :shop_id, :category_item_id
  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end
  
end
