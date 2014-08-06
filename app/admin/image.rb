ActiveAdmin.register Image do
  #menu :label => proc{ I18n.t("images") }

  #permit_params :name, :url, :path, :imageable_id, :imageable_type

  #scope :all, :default => true
  #scope :global
  #scope :user_specific

    #show do |ad|
    #  attributes_table do
    #    #row :image do
    #    #  image_tag(ad.image.url)
    #    #end
    #    row :image_medium do
    #      image_tag ad.image.url(:medium)
    #    end
    #    row :image_thumb do
    #      image_tag ad.image.url(:thumb)
    #    end
    #  end
    #end

    index do
      column :id
      column :image do |ad|
        image_tag ad.image.url(:thumb)
      end
      column :name
      #column :url
      #column :path
      column :image_content_type
      column :image_file_name
      column :image_file_size
      column :image_updated_at

      #column :created_at
      #column :updated_at

      actions
    end


  form html: { multipart: true }  do |f|
    f.inputs "image"  do
      f.input :name, :label => 'image name'
      f.input :path, :label => 'image path'
    end
    f.inputs "image url"  do
      f.file_field :image
      #f.input :url
      #  file_field_tag("image_attached_images_image", multiple: true, name: "images[attached_images_attributes][][image]")
    end
    f.actions
    #f.inputs do
    #  f.button
    #end # :submit
  end

  controller do
    #after_save :store_photo
    #after_update :store_photo

    #def index
    #
    #end

    #def new
    #  image = Image.new
    #end

    def create
      image = Image.new (image_params)
      #image.imageable.shop
      #image.url =
      if image.save
        #store_photo params[:image]
        redirect_to({ action: 'index' }, alert: "Saved")
      else
        render action: 'new'
      end
    end

    def update
      image = Image.find (params['id'])
      image.attributes = image_params
      #image.image_file_name = "sdaf"
      if image.save
      #redirect "/admin/images/index"
      #redirect_to images_url

      #store_photo params[:images]
        redirect_to({ action: 'index' }, alert: "Something serious happened")
      else
        render action: 'new'
      end
    end

    private
      def image_params
        #permit_params :name, :url, :path, :imageable_id, :imageable_type, :images
        #permitted :name, :url, :path, :imageable_id, :imageable_type, :images
        params.require(:image).permit(:image, :name, :url, :path, :imageable_id, :imageable_type)
      end

      #params.require(:user).permit(:avatar)


      PHOTO_STORE = File.join Rails.root, 'public', 'photo_store'

      def store_photo file_data
        @file_data = file_data
        if @file_data
          FileUtils.mkdir_p PHOTO_STORE
          photo_filename = file_data.original_filename
          File.open(photo_filename, 'wb') do |f|
            f.write(@file_data.read)
          end
          @file_data = nil
        end
      end
      def photo=(file_data)
        unless file_data.blank?
          @file_data = file_data
          self.extension = file_data.original_filename.split('.').last.downcase
        end
      end


      #def photo_filename
      #  File.join PHOTO_STORE, "#{id}.#{extension}"
      #end
      #def photo_path
      #  "/photo_store/#{id}.#{extension}"
      #end

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
