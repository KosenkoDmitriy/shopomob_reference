ActiveAdmin.register ContactItem do
  menu :label => proc{ I18n.t("contacts.other") } , :parent => I18n.t("contacts.other")

  permit_params :contact_item, :contact_type_id, :fio, :department, :shop_id, :value

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
