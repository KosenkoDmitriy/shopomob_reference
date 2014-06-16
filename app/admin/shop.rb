ActiveAdmin.register Shop do
  #permit_params :shop, :name, :domain, :www, :email, :postal_code, :parent_id, :address, :time_work, :favorite, :rated, :image_file_name, :image_content_type, :image_file_size, :image_updated_at

  controller do
    def create
      #@shop = Shop.create(shop_params)
      @shop = Shop.new (shop_params)
      cat_ids = params[:shop][:category_ids]
      cat_ids.shift
      cat_ids.each do |ci|
        #@shop.categories << Category.find(ci.to_i)
        if ci.to_i > 0
          c = Category.find(ci.to_i)
          if c
            @shop.categories.append(c)
          end
        end
      end
      if @shop.save
        redirect_to action: "index"
      else
        render "new"
      end
      #redirect_to({ action: 'index' }, alert: "Something serious happened")
    end

    def update
      @shop = Shop.find(params['id']) #update (params['id'], shop_params)
      @shop.attributes = shop_params
      @shop.categories.delete_all
      cat_ids = params[:shop][:category_ids]
      cat_ids.shift
      cat_ids.each do |ci|
        #@shop.categories << Category.find(ci.to_i)
        #if (ci.to_i > )
        if ci.to_i > 0
          c = Category.find(ci.to_i)
          if c
            @shop.categories.append(c)
          end
        end
      end
      if @shop.save
        redirect_to action: "index"
      else
        render "new"
      end
      #redirect_to({ action: 'index' }, alert: "Something serious happened")
    end

    private
    def shop_params
      #params.require(:shop).permit(:image, :image_file_name, :image_file_size, :image_content_type, :image_updated_at, ) #:image_file_name, :image_content_type, :image_file_size, :image_updated_at)
      params.require(:shop).permit(:category_id, :image, :name, :domain, :postal_code, :address, :time_work, :email, :www, :favorite, :rated, images_attributes: [:id, :image, :_destroy], contact_items_attributes: [:id, :value, :contact_type_id, :_destroy])
    end
  end


  form do |f|
    f.inputs "shop" do
      f.inputs
      f.has_many :images, :heading => 'Images' do |ff|
        ff.input :image, :label => "Image", :hint => ff.template.image_tag(ff.object.image.url(:thumb))
        ff.input :_destroy, :as=>:boolean, :required => false, :label => 'Remove image'
      end
      f.has_many :contact_items, :heading => 'Contact Items' do |ci|
        ci.input :value
        ci.input :contact_type
        #ci.input :value, :label => "category_item"
        ci.input :_destroy, :as=>:boolean, :required => false, :label => 'Remove'
      end
      #f.belongs_to :categories, :heading => 'Categories' do |c|
      #  c.input :name
      #  c.input :id
      #  #ff.input :value, :label => "category_item"
      #  #ff.input :destroy, :as=>:boolean, :required => false, :label => 'Remove '
      #end

      #f.input :categories, as: :check_boxes, :multiple => true, member_label: :name
      f.input :categories, :multiple => true, member_label: :name
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

  #form html: { multipart: true }  do |f|
  #
  #  #f.inputs "contacts item" do
  #  #  f.has_many :categories, :heading => 'Themes'  do |cf|
  #  #    cf.input :name
  #  #  end
  #  #end
  #
  #
  #  #f.inputs "image url" do
  #  #  f.file_field :image
  #  #    f.input :image_file_name
  #  ##  file_field_tag("image_attached_images_image", multiple: true, name: "images[attached_images_attributes][][image]")
  #  #end
  #
  #  f.actions
  #end


end
