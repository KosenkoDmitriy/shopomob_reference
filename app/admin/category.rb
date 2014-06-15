ActiveAdmin.register Category do
  permit_params :name

  controller do
    def create
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
    end

    private
    def category_params
      params.require(:category).permit(:parent_id, :image, :name, :created_at, :updated_at, image_attributes: [:id, :image, :_destroy], shop_ids: [:id, :name, :category_id, :_destroy])
    end
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
