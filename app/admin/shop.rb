ActiveAdmin.register Shop do
  #permit_params :shop, :name, :domain, :www, :email, :postal_code, :parent_id, :address, :time_work, :favorite, :rated, :image_file_name, :image_content_type, :image_file_size, :image_updated_at

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
      params.require(:shop).permit(:category_ids, :category_item_ids, :id, :parent_id, :image, :name, :domain, :postal_code, :address, :time_work, :email, :www, :favorite, :rated, images_attributes: [:id, :image, :_destroy], contact_items_attributes: [:id, :value, :contact_type_id, :_destroy], category_items_attributes: [:id, :name, :_destroy], categories_attributes: [:id, :name, :_destroy])
    end
  end


  form do |f|
    f.inputs "shop" do
      f.inputs
    end

    f.inputs "Categories" do
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

    f.inputs "contacts" do
      f.has_many :contact_items, :heading => 'Contact Items' do |ci|
        ci.input :value
        ci.input :contact_type
        #ci.input :value, :label => "category_item"
        ci.input :_destroy, :as=>:boolean, :required => false, :label => 'Remove'
      end
    end

    f.inputs "images" do
      f.has_many :images, :heading => 'Images' do |ff|
        ff.input :image, :label => "Image", :hint => ff.template.image_tag(ff.object.image.url(:thumb))
        ff.input :_destroy, :as=>:boolean, :required => false, :label => 'Remove image'
      end
    end

    f.actions
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

end
