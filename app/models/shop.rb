class Shop < ActiveRecord::Base
  belongs_to :parent, class_name: "Shop"

  #has_and_belongs_to_many :categories # should use has_many :through if you need validations, callbacks, or extra attributes on the join model.
  has_many :categories_shops
  has_many :categories, :through => :categories_shops
  accepts_nested_attributes_for :categories, :allow_destroy => true

  has_many :category_items_shops
  has_many :category_items, through: :category_items_shops
  accepts_nested_attributes_for :category_items, :allow_destroy => true
  #attr_accessor :category_items_ids
  #before_save :assign_categories
  #
  #private
  #def assign_categories
  #  category_items_ids.each do |cid|
  #    self.category_items.build(category_item_id: cid )
  #  end
  #end

  has_many :contact_items, dependent: :destroy
  accepts_nested_attributes_for :contact_items, :allow_destroy => true

  has_many :images, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :images, :allow_destroy => true

  belongs_to :status

  #Shop.select(:name,:address).group(:name,:address).having("count(*) > 1").count #search duplicates
  def self.dedupe2
    # find all models and group them on keys which should be common
    grouped = all.group_by{|model| [model.name,model.address] }
    grouped.values.each do |duplicates|
      # the first one we want to keep right?
      first_one = duplicates.shift # or pop for last one
      # if there are any more left, they are duplicates
      # so delete all of them
      duplicates.each{|double| double.destroy} # duplicates can now be destroyed
    end
  end

  def self.dedupe
    ct_phone = ContactType.find_or_create_by(name:'phone', value:'тел')
    ct_address = ContactType.find_or_create_by(name:'address', value:'адрес')

    # find all models and group them on keys which should be common
    #grouped = all.group_by{|model| [model.name] }
    grouped = all.group(:name).having("count(*) > 1")
    grouped.each do |shop_grouped|
      duplicates = all.where(name:shop_grouped.name)
      #duplicates = Shop.where(name:"Princess Z")
      shop_first = duplicates.first
      duplicates[1..duplicates.count].each do |double|
        shop_first.email = double.email if double.name.present? && shop_first.email.blank?
        shop_first.tags = double.tags if double.tags.present? && shop_first.tags.blank?
        shop_first.www = double.www if double.www.present? && shop_first.www.blank?
        shop_first.time_work = double.time_work if double.time_work.present? && shop_first.time_work.blank?
        shop_first.postal_code = double.postal_code if double.postal_code.present? && shop_first.postal_code.blank?
        ci = ContactItem.find_or_create_by(value:double.address, contact_type:ct_address)

        shop_first.contact_items << ci if (shop_first.address != double.address)
        #shop_first.contact_items = (shop_first.contact_items+double.contact_items).uniq if double.contact_items

        double.contact_items.each do |ci|
          #ci_new = ci
          #ci_new.shop = shop_first
          ci_new=ContactItem.find_or_create_by!(shop:shop_first, value:ci.value, contact_type:ci.contact_type, department:ci.department,fio:ci.fio)
          #ci_new.attributes = ci.attributes.except(:id)
          #ci_new.shop_id = shop_first.id
          #ci_new.save!
          #shop_first.contact_items.append(ci_new)
        end
        #shop_first.contact_items.each do |ci|
        #  ci.shop_id=shop_first.id
        #  ci.save!
        #end
        shop_first.contact_items = (shop_first.contact_items).uniq

        if double.category_items.present?
          double.category_items.each do |c|
              tcat = CategoryItem.find(c.id) if c.id
              shop_first.category_items.append(tcat) if tcat && shop_first.category_items.present?
          end
        end

        #if double.category_items.present? #&& shop_first.category_items.present?
        #  #shop_first.category_items = (shop_first.category_items+double.category_items).uniq!
        #  tcats=(shop_first.category_items+double.category_items).uniq!
        #  shop_first.category_items.delete_all
        #  shop_first.category_items=tcats
        #end
        shop_first.save!
        double.destroy! # duplicates can now be destroyed
      end
    end
  end

  #attr_accessible :title, :content
  #has_seo_meta :title
  #has_seo_meta :field, nested: true
  belongs_to :seo
  accepts_nested_attributes_for :seo, :allow_destroy => true#, :reject_if => :all_blank

end
