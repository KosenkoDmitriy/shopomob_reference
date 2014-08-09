# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#c = Category.create(name:'Category 1')
#sc = Category.create(name:'1.1 Category', parent:c)
#
#s = c.shops.create(name:'Shop 1')
#
#ct_mail = ContactType.create(name:'email', value:'Email Address')
#ct_url = ContactType.create(name:'url', value:'Website or other link')
#ct_phone = ContactType.create(name:'phone', value:'Phone Number')
#
#ci = ContactItem.create(name:'Phone Number (mobile)', value:'7324134214', shop:s, contact_type:ct_phone)
#ci = ContactItem.create(name:'Email (Sales)', value:'sales@ex.com', shop:s, contact_type:ct_mail)
#ci = ContactItem.create(name:'Website (Official)', value:'www.ex.com', shop:s, contact_type:ct_url)
#ci = ContactItem.create(name:'Facebook', value:'www.facebook.com/ex', shop:s, contact_type:ct_url)


#AdminUser.create!(:email => 'spree@example.com', :password => 'spree123', :password_confirmation => 'spree123')
AdminUser.create!(:email => 'shopomob@shopomob.ru', :password => 'shopomobpass', :password_confirmation => 'shopomobpass')

#Status.create(no: 0, title: 'none', text: '')
#Status.create(no: 1, title: 'rejected', text: 'Отклонен')
#Status.create(no: 2, title: 'removed', text: 'Удален')
#Status.create(no: 3, title: 'call_later', text: 'Позвоните позже')
#Status.create(no: 4, title: 'draft', text: 'Черновик')
#Status.create(no: 5, title: 'approved', text: 'Одобрен/Опубликован/Подтвержден')

Status.create(no: 1, title: 'не отвечает на звонок', text: '')
Status.create(no: 2, title: 'удалена', text: '')
Status.create(no: 3, title: 'просит перезвонить', text: '')
Status.create(no: 4, title: 'ожидаем актуальной информации', text: '')
Status.create(no: 5, title: 'ожидаем оплаты', text: '')
Status.create(no: 6, title: 'подтверждена', text: '')

require 'csv'
path_to_app = File.dirname(__FILE__)+'/csv/'
path_to_img = File.dirname(__FILE__)+'/images/'


file_path = "#{path_to_app}services.csv"
puts file_path
CSV.foreach(file_path, :headers => true, :col_sep => ',') do |row|
  item = Service.create( order_id: row['order_id'].to_i, title: row['title'], text: row['text'], url: row['url'])
  if (!row['image'].blank?)
    img_path = path_to_img + row['image']
    if (File.exists?(img_path))
      item.image = Image.create(:image=>File.open(img_path))
    end
  end
end

file_path = "#{path_to_app}banners.csv"
puts file_path
CSV.foreach(file_path, :headers => true, :col_sep => ',') do |row|
  item = Banner.create(shop_id: row['shop_id'].to_i, title: row['title'], url: row['url'])
  if (!row['image'].blank?)
    img_path = path_to_img + row['image']
    if (File.exists?(img_path))
      item.image = Image.create(:image=>File.open(img_path))
    end
  end
end

file_path = "#{path_to_app}tcats.csv"
puts file_path
CSV.foreach(file_path, :headers => true, :col_sep => ',') do |row|
  pid = row['parent_id'].to_i
  sc = CategoryItem.create(_id: row['_id'].to_i, name: row['name'], parent_id: pid, tags: row['tags'])
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


file_path = "#{path_to_app}cats.csv"
puts file_path
CSV.foreach(file_path, :headers => true, :col_sep => ',') do |row|
  sc = Category.create(_id: row['_id'].to_i, name: row['name'], tags: row['tags'])
  puts "cat: #{row['name']}"
end


file_path = "#{path_to_app}companies.csv"
puts file_path
CSV.foreach(file_path, :headers => true, :col_sep => ',') do |row|
  #puts "#{row['name']} #{row['address']} "
  pid = row['parent_id'].to_i
  shop = Shop.create(_id: row['_id'].to_i, name: row['name'], parent_id: pid, postal_code: row['address_index'].to_i, address: row['address'], time_work: row['time'], email: row['email'], www: row['www'], favorite: row['favorite'].to_i, rated: 0, tags: row['tags'], description: row['description'] ) #:
  if pid == 0
    #c = Category.create(name: row['name'] )
    puts "parent shop: #{row['name']}"
  else
    #c = Category.find_by(parent_id: row['parent_id'])
    puts "shop: #{row['name']}"
  end
end



ct_mail = ContactType.create(name:'email', value:'Email Address')
ct_url = ContactType.create(name:'url', value:'Website or other link')
ct_phone = ContactType.create(name:'phone', value:'Phone Number')
file_path = "#{path_to_app}phones.csv"
puts file_path
#_id	id_org	ord	phone	owner	owner_fio
CSV.foreach(file_path, :headers => true, :col_sep => ',') do |row|
  s = Shop.find_by(_id: row['id_org'].to_i)
  if s
    #ci = ContactItem.find_by(_id: row['id_trubr'].to_i)
    ci = ContactItem.create(fio: row['owner_fio'], department:row['owner'], value:row['phone'], shop:s, contact_type:ct_phone)

    if ci
      #c.category_item_ids.append( ci.id )
      s.contact_items.append( ci )
      s.save
      puts "#{s.name} | #{ci.department} | #{ci.value} "
    end
  end
end


=begin
file_path = "#{path_to_app}company_cats.csv"
puts file_path
CSV.foreach(file_path, :headers => true, :col_sep => ',') do |row|
  c = Category.find_by(_id: row['id_rubr'].to_i)
  if c
    s = Shop.find_by(_id: row['id_org'].to_i)
    if s
      #c.shop_ids.append( s.id )
      c.shops.append( s )
      c.save
      puts "#{s.name} | #{c.name} "
    end
  end
end


file_path = "#{path_to_app}cats_tcats.csv"
puts file_path
CSV.foreach(file_path, :headers => true, :col_sep => ',') do |row|
  c = Category.find_by(_id: row['id_rubr'].to_i)
  if c
    ci = CategoryItem.find_by(_id: row['id_trubr'].to_i)
    if ci
      #c.category_item_ids.append( ci.id )
      c.category_items.append( ci )
      c.save
      puts "#{c.name} | #{ci.name} "
    end
  end
end
=end