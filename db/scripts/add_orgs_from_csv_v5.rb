# AdminUser.delete_all
user=AdminUser.find_by(:email=>"shopomob@shopomob.ru")
AdminUser.create!(:email => 'shopomob@shopomob.ru', :password => 'shopomobpass', :password_confirmation => 'shopomobpass') if user.nil?

require 'csv'

def add_category_to_shop(shop_item, cat_name, cat_name2, cat_id)
  cat_name2 = cat_name2.strip if cat_name2.present?
  cat_item = CategoryItem.find_by(name: cat_name2) if cat_name2.present?
  #if (cat_item.present? && shop_item.present?)
  #  cat_item._id = cat_id if cat_id.present? && cat_id.to_i > 0
  #  cat_item.save!
  #  puts "tcat: #{cat_name2}|#{cat_id}|#{cat_item.tags}"
  #  #founded += 1
  #else
  #  puts "tcat not found: #{cat_name} | #{cat_name2} | #{cat_id}"
  #  #not_founded += 1
  #end

  #cat_item = CategoryItem.find_by(_id: row['lorg_cat_id']) if row['lorg_cat_id'].present?
  if (cat_item.present?)
    #shop_item.category_items << cat_item
    shop_item.category_items.append(cat_item)
    shop_item.category_items = (shop_item.category_items).uniq
    shop_item.save!
    puts "shop: #{shop_item.name}| tcat: #{cat_item.name}|#{cat_item.tags}"
    puts " tcat: #{cat_name2}|#{cat_id}|#{cat_item.tags}"
    #founded += 1
    return 1
  else
    puts "tcat not found: #{cat_name} | #{cat_name2} | #{cat_id}"
    #puts "shop not found: #{row['lorg_org_id']} | #{row['lorg_cat_id']}" #if shop_item.blank?
    #puts "tcat not found: #{row['lorg_org_id']} | #{row['lorg_cat_id']}" #if cat_item.blank?
    #not_founded += 1
    return 0
  end
end

#file_path = "#{path_to_app}/tcats.csv"
version = "v5"
file_path = Rails.root.join("db", "csv", "tcats.csv")
path_to_app = Rails.root.join('db', 'csv') #File.dirname(__FILE__)+'/csv/'
path_to_img = Rails.root.join('db', 'images')
puts file_path
CSV.foreach(file_path, :headers => true, :col_sep => ',') do |row|
  pid = row['parent_id'].to_i
  sc = CategoryItem.find_or_create_by(name: row['name'], parent_id: pid, tags: row['tags'])
  if (!row['image'].blank?)
    img_path = path_to_img + row['image']
    if (File.exists?(img_path))
      sc.image = Image.create(:image=>File.open(img_path))
    end
  end

  if pid == 0
    #c = Category.create(name: row['name'] )
    puts "parent tcat: #{row['name']}"
  else
    #c = Category.find_by(parent_id: row['parent_id'])
    puts "tcat: #{row['name']}"
  end
end

versions = ["v5"]
versions.each do |version|
  file_path = Rails.root.join("db", "csv", version, "companies.csv")
#file_path = Rails.root.join("db", "csv", "orgs.csv") #for test

  puts file_path

  shops_new = []
  shops_exist = []
  addresses = []
  i = 0
  ct_phone = ContactType.find_or_create_by(name:'phone', value:'тел')
  ct_address = ContactType.find_or_create_by(name:'address', value:'адрес')

  CSV.foreach(file_path, :headers => true, :col_sep => ',') do |row|
    if (row["org_address_city"] == "1")

      #puts "#{row['name']} #{row['address']} "
      pid = row['org_parent_id'].to_i
      address="#{row['org_cache_address'].gsub("г. ", "").gsub("пр-т. ", "пр. ")}"

      name = row['org_name']

      org_keywords_arr = []
      org_name_arr = []
      name.split.each do |item|
        org_name_arr << Unicode::capitalize(item) if item==Unicode::upcase(item)
        org_keywords_arr << item if item==Unicode::downcase(item)
      end
      name = org_name_arr.join(" ").gsub('"', '').strip

      tags = "#{row['tags']} #{org_keywords_arr.join(' ')}"

      searchName = "#{name}"
      #shops = Shop.where("name like ? or name like ? or name like ?", Unicode::downcase(searchName), Unicode::upcase(searchName), Unicode::capitalize(searchName))
      shopNew = Shop.new(_id: row['_id'].to_i, name: name.strip, parent_id: pid, postal_code: row['org_address_index'].to_i, address: address.strip, time_work: row['org_cache_mode'], email: row['org_email'], www: row['org_http'], favorite: 0, rated: 0, tags: tags )

      #if (shops.blank?)
      if shopNew.name.present?
        shopNew.save!
        shops_new << shopNew
        i += 1
        puts "#{i} new: #{name}"

      end
      #else
      #  shops.each do |shop|
      #    puts "finded: #{shop.name} | #{shopNew.name}"
      #    shops_exist << shop
      #    #ci = ContactItem.find_or_create_by(fio:"", department:"", value:address, shop:shop, contact_type:ct_address)
      #    ci = ContactItem.find_or_create_by(value:address, contact_type:ct_address)
      #    shop.contact_items << ci if (shopNew.address != shop.address)
      #    shop.contact_items = (shop.contact_items).uniq
      #    shop.save!
      #    addresses << ci
      #    #shop.contact_items = (shop.contact_items + addresses).uniq
      #  end
      #end


      #Shop.all.each do |shop|
      #  shop.name.include?(shopNew)
      #end
      #if pid == 0
      #  #c = Category.create(name: row['name'] )
      #  puts "parent shop: #{row['org_name']}"
      #else
      #  #c = Category.find_by(parent_id: row['parent_id'])
      #  puts "shop: #{row['org_name']}"
      #end
    end
  end

  puts "shops_exist.count: #{shops_exist.count}"
  puts "addresses.count (added to the existing shops): #{addresses.count}"
  puts "shops_new.count: #{shops_new.count}"

#puts "add addresses to exists orgs"
#shops_exist.each do |shop|
#  puts "name: #{shop.name}"
#end

#puts "new"
#shops_new.each { |shop| puts shop.name }

  file_path = Rails.root.join("db", "csv", version, "phones.csv")
  puts file_path
#_id	id_org	ord	phone	owner	owner_fio
  CSV.foreach(file_path, :headers => true, :col_sep => ',') do |row|
    s = Shop.find_by(_id:row['ph_org_id'].to_i)
    if s
      #ci = ContactItem.find_by(_id: row['id_trubr'].to_i)
      ci = ContactItem.find_or_create_by(fio: row['ph_ownerFIO'], department:row['ph_owner'], value:row['ph_number'], shop:s, contact_type:ct_phone)
      if ci
        #c.category_item_ids.append( ci.id )
        s.contact_items.append( ci )
        s.contact_items = (s.contact_items).uniq
        s.save
        puts "#{s.name} | #{ci.department} | #{ci.value} "
      end
    end
  end
end



file_path = Rails.root.join("db", "csv", version, "cats_orgs.csv")
puts file_path
status = not_founded = founded = 0
CSV.foreach(file_path, :headers => true, :col_sep => ',') do |row|
  cat_id = row["lorg_cat_id"].to_i if row['lorg_cat_id'].present? && row['lorg_cat_id'].to_i > 0
  shop_id = row['lorg_org_id'] if row['lorg_org_id'].present? && row['lorg_org_id'].to_i > 0
  shop_item = Shop.find_by(_id: row['lorg_org_id'].to_i) if row['lorg_org_id'].present? && row['lorg_org_id'].to_i > 0

  file_path = Rails.root.join("db", "csv", version, "cats.csv")
  puts file_path

  CSV.foreach(file_path, :headers => true, :col_sep => ',') do |row|
    if (row["_id"].to_i == cat_id)
      pid = row['parent_id'].to_i
      cat_items = row['cat_name2'].split(";") if row['cat_name2'].present?
      if (cat_items.present? && cat_items.size > 0)
        cat_items.each do |cat_item|
          status = add_category_to_shop(shop_item, row["cat_name"], cat_item, row["_id"]) if shop_item.present?
        end
      else
        status = add_category_to_shop(shop_item, row["cat_name"], row["cat_name2"], row["_id"]) if shop_item.present?
      end
      if status > 0
        founded += 1
      else
        not_founded += 1
      end
    end
  end
end
puts "tcats:\n all: #{CategoryItem.count} | founded: #{founded}| not found: #{not_founded}"
puts "not founded: #{not_founded} | founded: #{founded}"
puts "shop all: #{Shop.count}"



#remove duplicates
#Shop.dedupe

