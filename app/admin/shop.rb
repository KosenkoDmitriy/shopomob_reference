ActiveAdmin.register Shop do
  #permit_params :shop, :name, :domain, :www, :email, :postal_code, :parent_id, :address, :time_work, :favorite, :rated, :image_file_name, :image_content_type, :image_file_size, :image_updated_at

  menu :label => proc{ I18n.t("companies") }
  #menu :priority => 2, url: ->{ app_customers_path(locale: I18n.locale) } # Pass the locale to the menu link
  #
  #action_item do
  #  link_to I18n.t("shops"), new_app_customer_path(locale: I18n.locale) # Pass the locale to the new button
  #end

  controller do
    def create
      #@shop = Shop.create(shop_params)
      @shop = Shop.new (shop_params)
      ids = params[:shop][:category_ids]
      ids.shift
      ids.each do |id|
        #@shop.categories << Category.find(ci.to_i)
        if id.to_i > 0
          c = Category.find(id.to_i)
          if c
            @shop.categories.append(c)
          end
        end
      end
      ids = params[:shop][:category_item_ids]
      ids.shift
      ids.each do |id|
        if id.to_i > 0
          c = CategoryItem.find(id.to_i)
          if c
            @shop.category_items.append(c)
          end
        end

      end
      if @shop.save
        redirect_to action: "index"
      else
        render "new"
      end
      #redirect_to({ action: 'index' }, alert: "Created")
    end

    def update
      #@shop = Shop.update(params['id'], shop_params)

      @shop = Shop.find(params['id']) #update (params['id'], shop_params)
      @shop.attributes = shop_params
      @shop.categories.delete_all
      ids = params[:shop][:category_ids]
      ids.shift
      ids.each do |ci|
        #@shop.categories << Category.find(ci.to_i)
        #if (ci.to_i > )
        if ci.to_i > 0
          c = Category.find(ci.to_i)
          if c
            @shop.categories.append(c)
          end
        end
      end

      @shop.category_items.delete_all
      ids = params[:shop][:category_item_ids]
      ids.shift
      ids.each do |id|
        if id.to_i > 0
          c = CategoryItem.find(id.to_i)
          if c
            @shop.category_items.append(c)
          end
        end
      end

      if @shop.save
        redirect_to action: "index"
      else
        render "new"
      end
      #redirect_to({ action: 'index' }, alert: "Updated")
    end

    private
    def shop_params
      params.require(:shop).permit(:description, :tags, :category_ids, :category_item_ids, :id, :parent_id, :image, :name, :domain, :postal_code, :address, :time_work, :email, :www, :favorite, :rated, images_attributes: [:id, :image, :_destroy], contact_items_attributes: [:id, :value, :contact_type_id, :_destroy], category_items_attributes: [:id, :name, :_destroy], categories_attributes: [:id, :name, :_destroy])
    end
  end


  form do |f|
    f.inputs I18n.t("company.label") do
      f.input :name, label: I18n.t("company.name")
      f.input :postal_code, label: I18n.t("company.postal_code")
      f.input :address, label: I18n.t("company.address")
      f.input :time_work, label: I18n.t("company.time_work")
      f.input :email, label: I18n.t("company.email")
      f.input :www, label: I18n.t("company.www")
      f.input :rated, label: I18n.t("company.rated")
      f.input :description, label: I18n.t("company.description")
      f.input :tags, label: I18n.t("company.tags"), hint: I18n.t("company.keywords_space")
    end

    f.inputs I18n.t("cats") + "/" + I18n.t("tcats") do
      #f.has_many :category_items, :heading => 'TCategories' do |c|
      #  c.input :id, :as => :select, :collection => CategoryItem.all.map{|u| ["#{u.name}", u.id]}
      #  c.input :_destroy, :as => :boolean, :required => false, :label => 'Remove'
      #end
      #
      #f.has_many :categories, :heading => 'Categories' do |c|
      #    #if !c.object.nil?
      #      c.input :id, :as => :select, :collection => Category.all.map{|u| ["#{u.name}", u.id]}
      #      c.input :_destroy, :as => :boolean, :required => false, :label => 'Remove'
      #    #end
      #end
      f.input :categories, :multiple => true, member_label: :name, :as => :select
      f.input :category_items, :multiple => true, member_label: :name

      #f.input :category_items, :label => 'TCategories', :as => :select, :collection => CategoryItem.all.map{|u| ["#{u.id}, #{u.name}", u.id]}
      #f.input :categories, as: :check_boxes, :multiple => true, member_label: :name
    end

    f.inputs I18n.t("contacts") do
      #f.has_many :contact_items, :heading => I18n.t("contacts") do |c|
      #    #if !c.object.nil?
      #      c.input :id, :as => :select, :collection => ContactItem.where(shop_id:params['id']).map{|u| ["#{u.value}", u.id]}
      #      c.input :_destroy, :as => :boolean, :required => false, :label => 'Remove'
      #    #end
      #end

      #f.has_many :contact_items, :heading => I18n.t("contacts") do |ci|
      f.has_many :contact_items do |ci|
        ci.input :value
        ci.input :contact_type
        #ci.input :value, :label => "category_item"
        ci.input :_destroy, :as=>:boolean, :required => false, :label => I18n.t('remove')
      end
    end

    f.inputs I18n.t("images") do
      f.has_many :images, :heading => 'Images' do |ff|
        ff.input :image, :label => "Image", :hint => ff.template.image_tag(ff.object.image.url(:thumb))
        ff.input :_destroy, :as=>:boolean, :required => false, :label => I18n.t('remove')
      end
    end

    f.actions
  end

  index do
    actions
    column I18n.t("company.id"), :id do |shop|
      link_to shop.id, admin_shop_path(shop)
    end
    column I18n.t("company.name"), :name
    column I18n.t("contacts"), :id do |shop|
      ci = ContactItem.where(shop_id:shop.id).map{|u| ["#{u.value}", "#{u.contact_type.name if u.contact_type}" ]}
      ci.each do |item|
        if item[0]
          div "#{item[1]}: #{item[0]}, "
        end
      end
    end

    column I18n.t("company.address"), :address
    column I18n.t("company.time_work"), :time_work
    column I18n.t("company.email"), :email
    column I18n.t("company.website"), :www

    column I18n.t("company.tags"), :tags
    column I18n.t("company.postal_code"), :postal_code
    column I18n.t("company.rated"), :rated

  end

  #show do |ad|
  #  attributes_table do |i|
  #    #row :image do
  #    #  image_tag(ad.image.url)
  #    #end
  #    row :image_medium do
  #      image_tag i.image.url(:medium)
  #    end
  #    #row :image_thumb do
  #    #  image_tag ad.image.url(:thumb)
  #    #end
  #  end
  #end

  show :title =>  I18n.t('shop') do |f|
    attributes_table do
      row I18n.t("company.name") do
        f.name
      end
      row I18n.t("company.description") do
        f.description
      end
      row I18n.t("company.postal_code") do
        f.postal_code
      end
      row I18n.t("company.address") do
        f.address
      end
      row I18n.t("company.time_work") do
        f.time_work
      end
      row I18n.t("company.email") do
        f.email
      end
      row I18n.t("company.website") do
        f.www
      end
      row I18n.t("company.rated") do
        f.rated
      end
      row I18n.t("company.tags") do
        f.tags
      end
      row I18n.t("contacts") do
        ci = ContactItem.where(shop_id:params["id"]).map{|u| ["#{u.value}", "#{u.contact_type.name if u.contact_type}" ]}
        ci.each do |book|
          if book[0]
            h4 "#{book[1]}: #{book[0]}"
          end
        end
      end
      row :image do
        image_tag(f.images.first.image_url) if f.images.first !=nil #? f.images.first !=nil : image_tag(Image.first.image.url)
      end
    end
    #f.images
    #f.has_many :contact_items, :heading => I18n.t("contacts") do |ci|
    #  ci.input :value
    #  ci.input :contact_type
    #  #ci.input :value, :label => "category_item"
    #  ci.input :_destroy, :as=>:boolean, :required => false, :label => 'Remove'
    #end
  end



end
