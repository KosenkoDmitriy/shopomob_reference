ActiveAdmin.register Category do
  permit_params :name
  #menu :parent => "Category"
  menu :label => proc{ I18n.t("cats") } , :parent => I18n.t("cats")

  controller do
    #before_filter :initialize_categories, :only => [:new, :edit]

    def create
      #@cat = Category.create (category_params)
      #@cat = Category.create (category_params)
      #@cat.shops = shop_params

      @cat = Category.new (category_params)
      ids = params[:category][:shop_ids]
      ids.shift
      ids.each do |id|
        if id.to_i > 0
          s = Shop.find(id.to_i)
          if s
            @cat.shops.append(s)
          end
        end
      end

      if @cat.save
        redirect_to action: "index"
        #redirect_to({ action: 'index' }, alert: "Something serious happened")
      else
        render "new"
      end
      #redirect_to action: "index"

    end

    def update
      @cat = Category.update(params['id'], category_params)

      @cat = Category.find (params['id'])
      @cat.attributes = category_params
      ids = params[:category][:shop_ids]
      @cat.shops.delete_all
      #@cat.shops.destroy
      ids.shift
      ids.each do |id|
        if id.to_i > 0
          s = Shop.find(id.to_i)
          if s
            @cat.shops.append(s)
          end
        end
      end

      if @cat.save
        redirect_to action: "index"
        #redirect_to({ action: 'index' }, alert: "Something serious happened")
      else
        render "edit"
      end
      #redirect_to action: "index"

    end

    private
    def category_params
      params.require(:category).permit(:parent_id, :image, :name, :created_at, :updated_at, image_attributes: [:id, :image, :_destroy], shop_ids: [:id, :name, :category_id, :_destroy])
    end

    def shop_params
      params.require(:category).permit(shops_attributes: [:id, :name, :_destroy])
    end

    #def initialize_categories
    #  shops = if @cat.shops.present?
    #
    #          else
    #
    #          end
    #end
  end


  form do |f|
    f.inputs "Category" do
      f.inputs :heading => 'Category'
      #f.has_many :shops, :heading => 'Shops' do |ff|
      #  ff.input :name, :label => "Shop"#, :hint => ff.template.image_tag(ff.object.image.url(:thumb))
      #  #ff.input :_destroy, :as=>:boolean, :required => false, :label => 'Remove shop'
      #end
    end

    f.inputs "Shops" do
      f.input :shops, :multiple => true, member_label: :name
      #f.has_many :shops, :heading => 'Categories' do |c|
      #  #if !c.object.nil?
      #  c.input :id, :as => :select, :collection => Shop.all.map{|u| ["#{u.name}", u.id]}
      #  c.input :_destroy, :as => :boolean, :required => false, :label => 'Remove'
      #  #end
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
  
end
