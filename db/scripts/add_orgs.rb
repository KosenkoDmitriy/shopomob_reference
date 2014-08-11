# load './db/scripts/add_orgs.rb'

require 'csv'
file_path = Rails.root.join("db", "csv", "companies.csv")

puts file_path

shops_new = []
shops_exist = []
ct_phone = ContactType.find_or_create_by(name:'phone', value:'Phone Number')
default_town = "Владикавказ"
CSV.foreach(file_path, :headers => true, :col_sep => ',') do |row|
  #puts "#{row['name']} #{row['address']} "
  pid = row['parent_id'].to_i
  address="#{default_town}, #{row['address']}"
  #shop = Shop.create(_id: row['_id'].to_i, name: row['name'], parent_id: pid, postal_code: row['address_index'].to_i, address: row['address'], time_work: row['time'], email: row['email'], www: row['www'], favorite: row['favorite'].to_i, rated: 0, tags: row['tags'], description: row['description'] ) #:
  shopNew = Shop.new(_id: row['_id'].to_i, name: row['name'], parent_id: pid, postal_code: row['address_index'].to_i, address: address, time_work: row['time'], email: row['email'], www: row['www'], favorite: row['favorite'].to_i, rated: 0, tags: row['tags'], description: row['description'] ) #:
  name = shopNew.name
  searchName = "#{name}%"
  shops = Shop.where("name like ? or name like ? or name like ?", searchName.downcase, searchName.upcase, searchName.capitalize)
  if (shops.blank?)
    puts "new: #{name}"
    shopNew.save!
    shops_new << shopNew
  else
    shops.each do |shop|
      puts "finded: #{shop.name} | #{shopNew.name}"
      shops_exist << shop
    end
  end


  #Shop.all.each do |shop|
  #  shop.name.include?(shopNew)
  #end
  if pid == 0
    #c = Category.create(name: row['name'] )
    puts "parent shop: #{row['name']}"
  else
    #c = Category.find_by(parent_id: row['parent_id'])
    puts "shop: #{row['name']}"
  end
end

puts "shops_exist.count: #{shops_exist.count}"
puts "shops_new.count: #{shops_new.count}"

#puts "exists"
#shops_exist.each do |shop|
#  puts "name: #{shop.name}"
#end

#puts "new"
#shops_new.each { |shop| puts shop.name }

file_path = Rails.root.join("db", "csv", "phones.csv")
puts file_path
#_id	id_org	ord	phone	owner	owner_fio
CSV.foreach(file_path, :headers => true, :col_sep => ',') do |row|
  s = Shop.find_by(_id: row['id_org'].to_i)
  if s
    #ci = ContactItem.find_by(_id: row['id_trubr'].to_i)
    ci = ContactItem.find_or_create_by(fio: row['owner_fio'], department:row['owner'], value:row['phone'], shop:s, contact_type:ct_phone)
    if ci
      #c.category_item_ids.append( ci.id )
      s.contact_items.append( ci )
      s.save
      puts "#{s.name} | #{ci.department} | #{ci.value} "
    end
  end
end