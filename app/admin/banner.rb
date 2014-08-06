ActiveAdmin.register Banner do
  menu :label => proc{ I18n.t("banners") } #, :parent => I18n.t("cats")

  #permit_params :shop_id, :title, :url, image_attributes: [ image: [:original_filename, :filename, :_destroy] ]
  permit_params :shop_id, :title, :url, image_attributes: [:id, :image, :_destroy]

  form do |f|
    f.inputs "Shop" do
      f.input :title
      f.input :url

      f.input :shop_id, :as => :select, :collection => Shop.all.order(name: :asc).map{|u| ["#{u.name}", u.id]}
    #f.has_many :shops, :heading => 'Categories' do |c|
      #if !c.object.nil?

      #c.input :_destroy, :as => :boolean, :required => false, :label => 'Remove'
      #end
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
