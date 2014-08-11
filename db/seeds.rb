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
def self.update_shops
  #key_words = ["Отдых","развлечения", "Магазины", "Красота", "здоровье", "Услуги", "Спорт","фитнес", "Авто", "Образование", "Туризм", "Недвижимость","строительство", "Финансы", "Транспорт", "Связь", "Домашние животные", "Государство","общество", "Бильярд", "Боулинг", "Дворцы и дома культуры", "Зоопарки", "Кинотеатры", "Музеи", "Ночные клубы", "Парки", "Парки культуры и отдыха", "Развлекательные центры", "Рестораны", "кафе", "бары", "Театры", "Танцы", "Школы танцев", "Гипермаркеты", "Детские магазины", "Книжные магазины", "Компьютерные магазины", "Мебель","Магазины мебели", "одежда", "обувь", "Магазины одежды и обуви", "продукты","Магазины продуктов", "ткань", "Магазины ткани", "хозтовары","Магазины хозтоваров", "электроника","Магазины электроники", "Музыкальные магазины", "Парфюмерные магазины", "Охота","Рыбалка","Охотничьи и рыболовные магазины", "Рынки", "Спортивные магазины", "Супермаркеты", "Торговые центры", "Ювелирные магазины", "Аптеки", "Больницы", "Женские консультации", "Клиники", "Медицинские центры", "Парикмахерские", "Поликлиники", "Родильные дома", "Салоны красоты", "Скорая помощь", "Солярии", "СПА-салоны", "Стоматология", "Травмпункты", "Аварийные службы", "Ателье по пошиву одежды", "Коммунальные службы", "Ломбарды", "Нотариус", "Нотариальные услуги", "Полиграфия", "Полиграфические услуги", "Прачечные", "Такси", "Фотоуслуги", "Химчистки", "Юристы", "Архитектура", "дизайн", "Архитектура и дизайн", "Бани", "сауны", "Бани и сауны", "Бассейны", "Спортивные комплексы", "Стадионы", "Фитнес-клубы", "Автозапчасти", "Автомагазины", "Автомойки", "Автосалоны", "Автосервисы", "автотехцентры", "Автосервисы, автотехцентры","Автостоянки", "Автостоянки, паркинги", "Автошколы", "АЗС", "ГАИ, ГИБДД", "МРЭО", "Шиномонтаж", "Библиотеки", "Вузы", "Детские сады", "Школы", "Авиа- и ж/д билеты", "Авиа билеты", "ж/д билеты", "Гостиницы", "Оформление виз", "Посольства, консульства", "Туроператоры", "Турфирмы", "Агентства недвижимости", "Аренда квартир и офисов", "Двери, дверные блоки", "Окна", "Строительные компании", "Строительные магазины", "Банки", "Банкоматы", "Обмен валют", "Автовокзалы", "Аэропорты", "Железнодорожные вокзалы", "Интернет-кафе", "Операторы сотовой связи", "Почта, телеграф", "Провайдеры", "Салоны связи", "Ветпомощь на дому", "Ветеринарные аптеки", "Ветеринарные клиники", "Зоосалоны, зоопарикмахерские", "Зоосалоны", "зоопарикмахерские", "Аптеки", "Автосервисы, автотехцентры", "Автосалоны", "Автозапчасти", "Автомагазины", "Авиа- и ж/д билеты", "Салоны связи", "Строительные магазины", "Военкоматы, комиссариаты", "ЗАГСы", "Налоговые инспекции, службы", "Органы власти", "Отделения милиции", "Паспортно-визовые службы", "Пенсионные фонды", "Религиозные учреждения", "Санэпидемстанции", "Суды", "Судебные приставы", "Центры занятости"]
  CategoryItem.where("parent_id>0").each do |ci|
    #CategoryItem.where("parent_id>0")[0..1].each do |ci|
    key_words = ci.tags.split(",")
    key_words.each do |key_word|
      key_word = (key_word.include?("/")) ? key_word.gsub("/", "-") : key_word
      parse_item key_word, ci
    end
  end
  Shop.dedupe #remove duplicates
end

def self.parse_item name, ci
  #http://localhost:3000/api/v1/t_category
  #c = CategoryItem.find(name)
  parsed_json= ""
  path_to_json = Rails.root.join('db', 'scripts', 'json', "#{name}.json")
  puts path_to_json

  if (File.exists?(path_to_json))
    parsed_json = File.open(path_to_json, 'r').read()
  end
  parsed_json = ActiveSupport::JSON.decode(parsed_json)#.load(parsed_json)#.encode(@parsed_json)

  #parsed_json["vpage"]["data"]["businesses"]["GeoObjectCollection"]["features"][0]["properties"]["CompanyMetaData"]["name"]
  orgs = parsed_json["vpage"]["data"]["businesses"]["GeoObjectCollection"]["features"]#[0]["properties"]["CompanyMetaData"]["name"]
  items = []
  orgs.each do |org|
    #item = org["properties"]["CompanyMetaData"]
    item = org["properties"]["CompanyMetaData"] || org["properties"]["PSearchObjectMetaData"]
    s = Shop.new
    s.name = item["name"] if item && item["name"]
    s.address = item["address"].gsub(" (Дзæуджыхъæу)", "") if item && item["address"]
    s.www = item["url"] if item && item["url"]
    #s.email = item["Phones"][0]["formatted"] if item["Phones"] #TODO: add phones to contact_item
    s.time_work = item["Hours"]["text"] if item && item["Hours"]
    #shop = Shop.find_or_initialize_by_name(s.name)
    #if (shop.new_record?)
    #
    #end
    phones = item["Phones"] if item
    if (!phones.blank?)
      phones.each do |phone|
        contactItem = ContactItem.create(value:phone["formatted"])
        s.contact_items.append( contactItem )
      end
    end
    s.category_items.append( ci )
    #shop = Shop.find_or_create_by(name:s.name)
    if (!s.name.blank?)
      shop = Shop.where("name == ? or name == ?", s.name.downcase, s.name.upcase).first #.find(name:s.name.upcase, name:s.name.downcase)
      if (shop.blank?)
        s.save() #create new shop
      else
        shop.update_attributes(s.attributes.except('id', 'updated_at', 'created_at'))
        s = shop
      end
      items << s
    end
  end
  ci.shops = (items+ci.shops).uniq()
end

#AdminUser.create!(:email => 'spree@example.com', :password => 'spree123', :password_confirmation => 'spree123')
AdminUser.delete_all
user=AdminUser.find_by(:email=>"shopomob@shopomob.ru")
AdminUser.create!(:email => 'shopomob@shopomob.ru', :password => 'shopomobpass', :password_confirmation => 'shopomobpass') if user.nil?


#Status.create(no: 0, title: 'none', text: '')
#Status.create(no: 1, title: 'rejected', text: 'Отклонен')
#Status.create(no: 2, title: 'removed', text: 'Удален')
#Status.create(no: 3, title: 'call_later', text: 'Позвоните позже')
#Status.create(no: 4, title: 'draft', text: 'Черновик')
#Status.create(no: 5, title: 'approved', text: 'Одобрен/Опубликован/Подтвержден')

Status.find_or_create_by(no: 1, title: 'не отвечает на звонок', text: '')
Status.find_or_create_by(no: 2, title: 'удалена', text: '')
Status.find_or_create_by(no: 3, title: 'просит перезвонить', text: '')
Status.find_or_create_by(no: 4, title: 'ожидаем актуальной информации', text: '')
Status.find_or_create_by(no: 5, title: 'ожидаем оплаты', text: '')
Status.find_or_create_by(no: 6, title: 'подтверждена', text: '')

ct_mail = ContactType.find_or_create_by(name:'email', value:'Email Address')
ct_url = ContactType.find_or_create_by(name:'url', value:'Website or other link')
ct_phone = ContactType.find_or_create_by(name:'phone', value:'Phone Number')

require 'csv'
path_to_app = File.dirname(__FILE__)+'/csv/'
path_to_img = File.dirname(__FILE__)+'/images/'


file_path = "#{path_to_app}services.csv"
puts file_path
CSV.foreach(file_path, :headers => true, :col_sep => ',') do |row|
  item = Service.find_or_create_by( order_id: row['order_id'].to_i, title: row['title'], text: row['text'], url: row['url'])
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
  item = Banner.find_or_create_by(shop_id: row['shop_id'].to_i, title: row['title'], url: row['url'])
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
  sc = CategoryItem.find_or_create_by(_id: row['_id'].to_i, name: row['name'], parent_id: pid, tags: row['tags'])
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

=begin

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
=end



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

update_shops() #load orgs from json files
load Rails.root.join('db', 'scripts', 'add_orgs.rb') #load orgs from csv file
