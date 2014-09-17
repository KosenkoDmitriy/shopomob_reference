ActiveAdmin.register Shop do
  menu :label => proc{ I18n.t("companies") }, :priority => 0

  #permit_params(:status_id, :shop_id, :description, :comments, :tags, :category_ids, :category_item_ids, :id, :parent_id, :image, :name, :domain, :postal_code, :address, :time_work, :email, :www, :favorite, :rated, images_attributes: [:id, :image, :_destroy], contact_items_attributes: [:id, :value, :contact_type_id, :_destroy], category_items_attributes: [:id, :name, :_destroy], categories_attributes: [:id, :name, :_destroy])

  config.sort_order = 'id_asc'

  #belongs_to :status

  #collection_action :autocomplete_category_item_name, :method => :get

  controller do
    #autocomplete :category_item, :name, :full => true
    #autocomplete :shop, :name, :full => true

    def new
      @shop = Shop.new
      @shop.build_seo
    end

    def edit
      @shop = Shop.find(params['id'])
      if @shop.seo_id.nil?
        @shop.build_seo
      end
    end

    def create
      @shop = Shop.new (shop_params.except(:category_items_attributes, :categories_attributes))

      ci_attrs = params[:shop][:categories_attributes]
      if ci_attrs
        ci_attrs.each do |ids|
          ids.each do |id|
            id = id["id"].to_i
            if id > 0
              c = Category.find(id)
              if c
                @shop.category_items.append(c)
              end
            end
          end
        end
      end

      ci_attrs = params[:shop][:category_items_attributes]
      if ci_attrs
        ci_attrs.each do |ids|
          ids.each do |id|
            id = id["id"].to_i
            if id > 0
              c = CategoryItem.find(id)
              if c
                @shop.category_items.append(c)
              end
            end
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
      @shop = Shop.find(params['id'])

      if @shop.update_attributes(shop_params.except(:category_items_attributes, :categories_attributes))
        attrs = params[:shop][:category_items_attributes]
        if attrs
          @shop.category_items.delete_all
          params[:shop][:category_items_attributes].each do |ci_ids|
            if ci_ids.present?
              ci_ids.each do |ci_id|
                cid = ci_id["id"].to_i
                destroy = ci_id["_destroy"].to_i
                ci = CategoryItem.find_by_id(cid)
                if ci
                  if destroy == 0
                    @shop.category_items.append(ci)
                  #else
                  #  @shop.category_items.delete(ci)
                  end
                  #@shop.category_items = @shop.category_items.uniq
                  @shop.save!
                end
              end
            end
          end
        end

        attrs = params[:shop][:categories_attributes]
        if attrs
          @shop.categories.delete_all
          params[:shop][:categories_attributes].each do |ci_ids|
            if ci_ids.present?
              ci_ids.each do |ci_id|
                cid = ci_id["id"].to_i
                destroy = ci_id["_destroy"].to_i
                ci = Category.find_by_id(cid)
                if ci
                  if destroy == 0
                    @shop.categories.append(ci)
                  end
                  @shop.save!
                end
              end
            end
          end
        end
        redirect_to action: "index"
      else
        render "new"
      end
    end

    def update_for_autocomplete #unused
      #@shop = Shop.update(params['id'], shop_params)
      @shop = Shop.find(params['id']) #update (params['id'], shop_params)

      @shop.attributes = shop_params #@shop.update_attributes(shop_params)
      if (params[:shop][:category_ids].present?)
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
      end

      if (params[:shop][:category_item_ids].present?)
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
      params.require(:shop).permit(:status_id, :shop_id, :description, :comments, :tags, :category_ids, :category_item_ids, :id, :parent_id, :image, :name, :domain, :postal_code, :address, :time_work, :email, :www, :favorite, :rated, images_attributes: [:id, :image, :_destroy], contact_items_attributes: [:id, :value, :contact_type_id, :_destroy], category_items_attributes: [:id, :name, :_destroy], categories_attributes: [:id, :name, :_destroy], seo_attributes: [:seo_id, :seo_title, :seo_description, :seo_keywords, :_destroy])
    end

  end


  form do |f|
    f.inputs I18n.t("company.label") do
      #f.input :id, label: I18n.t("company.id")
      f.input :name, label: I18n.t("company.name")
      f.input :postal_code, label: I18n.t("company.postal_code")
      f.input :address, label: I18n.t("company.address")
      f.input :time_work, label: I18n.t("company.time_work")
      f.input :email, label: I18n.t("company.email")
      f.input :www, label: I18n.t("company.www")
      f.input :rated, label: I18n.t("company.rated")
      f.input :description, label: I18n.t("company.description")
      f.input :tags, label: I18n.t("company.tags"), hint: I18n.t("company.keywords_space")
      #f.input :status_id, label: I18n.t("company.status.title"), hint: I18n.t("company.status.text")
      f.input :status, label: I18n.t("company.status.title"), hint: I18n.t("company.status.text")
      f.input :comments
    end

    f.inputs I18n.t("cats") + "/" + I18n.t("tcats") do
      #f.has_many :category_items, :heading => 'TCategories' do |c|
      #  c.input :id, :as => :select, :collection => CategoryItem.all.map{|u| ["#{u.name}", u.id]}
      #  c.input :_destroy, :as => :boolean, :required => false, :label => 'Remove'
      #end
      #
      f.has_many :categories, :heading => I18n.t('activerecord.models.category.other') do |c|
          if !c.object.nil?
            c.input :id, :as => :select, :selected => c.object.id, :collection => Category.order(:name).map{|u| ["#{u.name} #{u.id}", u.id]}, :label => I18n.t('activerecord.models.category.one')
            c.input :_destroy, :as => :boolean, :required => false, :label => 'Remove'
          end
      end
      #f.input :categories, :label => I18n.t("cats"), :multiple => true, member_label: :name, :as => :select

      #f.input :category_items, :multiple => true, member_label: :name
      #f.input :category_items, :multiple => true, member_label: :name, :as => :select

      ##autocomplete
      #f.has_many :category_items do |category_item|
      #  #category_item.inputs do |ci|
      #  #  category_item.autocomplete_field :name, :label=>I18n.t("activerecord.models.category_item.one"), :url => autocomplete_category_item_name_admin_shops_path
      #  #end
      #  if !category_item.object.nil?
      #    category_item.input :name, :as => :autocomplete, :url => autocomplete_category_item_name_admin_shops_path, label: I18n.t("activerecord.models.category_item.one")
      #    category_item.input :_destroy, :as => :boolean, :required => false, :label => I18n.t("remove")
      #  else
      #    #category_item.input :name, :as => :autocomplete, :url => autocomplete_category_item_name_admin_shops_path, collections: CategoryItem.all
      #  end
      #  #category_item.input :name, :as => :autocomplete, :url => '/admin/shops/autocomplete_category_item_name','data-delimiter' => ',', :multiple => true
      #end
      ##autocomplete

      #f.input :categories, as: :check_boxes, :multiple => true, member_label: :name

      #f.input :category_items, :input_html => { :class => "chosen-input" } # other model with has_many relation ship
      #f.input :category_items, :input_html => { :class => "chosen-select" } # other model with has_many relation ship

      #f.input :category_items, as: :select, :collection => CategoryItem.where("parent_id!=0").order(:name).map { |u| [u.name, u.id] }, :input_html => { include_blank: true, class: 'chosen-select' }
      f.has_many :category_items do |ci|
        if !ci.object.nil?
          ci.input :id, :as => :select, :selected => ci.object.id, :collection => CategoryItem.where("parent_id!=0").order(:name).map { |u| [u.name+" "+u.id.to_s, u.id] }, :label => I18n.t('activerecord.models.category_item.one')
          ci.input :_destroy, :as=>:boolean, :required => false, :label => I18n.t('remove')
        end
      end


      #f.association :category_items,
      #              collection: CategoryItem.all,
      #              include_blank: true,
      #              input_html: { class: 'chosen-select' }
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

    f.inputs I18n.t("seo") do  # Настройка полей SEO
      f.semantic_fields_for :seo do |j|
        j.inputs :seo_title, :seo_keywords, :seo_description
      end
    end
    f.actions
  end

  index do
    actions
    column I18n.t("company.id"), :id
    #column I18n.t("company.id"), :id do |shop|
    #  link_to shop.id, admin_shop_path(shop)
    #end
    column I18n.t("company.name"), :name
    column I18n.t("contacts.other"), :id do |shop|
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
    #column I18n.t("company.website"), :www
    #column I18n.t("company.tags"), :tags
    #column I18n.t("company.postal_code"), :postal_code
    #column I18n.t("company.rated"), :rated
    #column I18n.t("company.status.title"), :status_id
    column I18n.t("company.status.title"), :status

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
      row I18n.t("contacts.other") do
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
