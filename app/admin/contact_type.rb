ActiveAdmin.register ContactType do
  menu :label => I18n.t("contacts.types"), :parent => I18n.t("contacts.other")

  permit_params :name, :value, image_attributes: [:id, :image, :_destroy]

  form do |f|
    f.inputs "Contacts" do
      f.inputs :heading => 'Content'
    end

    f.inputs "Images" do
      f.has_many :image, :heading => 'Images' do |ff|
        ff.input :image, :label => "Image", :hint => ff.template.image_tag(ff.object.image.url(:thumb))
        ff.input :_destroy, :as=>:boolean, :required => false, :label => 'Remove image'
      end
    end
    f.actions
  end

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
