def self.update_shops
  #key_words = ["Отдых","развлечения", "Магазины", "Красота", "здоровье", "Услуги", "Спорт","фитнес", "Авто", "Образование", "Туризм", "Недвижимость","строительство", "Финансы", "Транспорт", "Связь", "Домашние животные", "Государство","общество", "Бильярд", "Боулинг", "Дворцы и дома культуры", "Зоопарки", "Кинотеатры", "Музеи", "Ночные клубы", "Парки", "Парки культуры и отдыха", "Развлекательные центры", "Рестораны", "кафе", "бары", "Театры", "Танцы", "Школы танцев", "Гипермаркеты", "Детские магазины", "Книжные магазины", "Компьютерные магазины", "Мебель","Магазины мебели", "одежда", "обувь", "Магазины одежды и обуви", "продукты","Магазины продуктов", "ткань", "Магазины ткани", "хозтовары","Магазины хозтоваров", "электроника","Магазины электроники", "Музыкальные магазины", "Парфюмерные магазины", "Охота","Рыбалка","Охотничьи и рыболовные магазины", "Рынки", "Спортивные магазины", "Супермаркеты", "Торговые центры", "Ювелирные магазины", "Аптеки", "Больницы", "Женские консультации", "Клиники", "Медицинские центры", "Парикмахерские", "Поликлиники", "Родильные дома", "Салоны красоты", "Скорая помощь", "Солярии", "СПА-салоны", "Стоматология", "Травмпункты", "Аварийные службы", "Ателье по пошиву одежды", "Коммунальные службы", "Ломбарды", "Нотариус", "Нотариальные услуги", "Полиграфия", "Полиграфические услуги", "Прачечные", "Такси", "Фотоуслуги", "Химчистки", "Юристы", "Архитектура", "дизайн", "Архитектура и дизайн", "Бани", "сауны", "Бани и сауны", "Бассейны", "Спортивные комплексы", "Стадионы", "Фитнес-клубы", "Автозапчасти", "Автомагазины", "Автомойки", "Автосалоны", "Автосервисы", "автотехцентры", "Автосервисы, автотехцентры","Автостоянки", "Автостоянки, паркинги", "Автошколы", "АЗС", "ГАИ, ГИБДД", "МРЭО", "Шиномонтаж", "Библиотеки", "Вузы", "Детские сады", "Школы", "Авиа- и ж/д билеты", "Авиа билеты", "ж/д билеты", "Гостиницы", "Оформление виз", "Посольства, консульства", "Туроператоры", "Турфирмы", "Агентства недвижимости", "Аренда квартир и офисов", "Двери, дверные блоки", "Окна", "Строительные компании", "Строительные магазины", "Банки", "Банкоматы", "Обмен валют", "Автовокзалы", "Аэропорты", "Железнодорожные вокзалы", "Интернет-кафе", "Операторы сотовой связи", "Почта, телеграф", "Провайдеры", "Салоны связи", "Ветпомощь на дому", "Ветеринарные аптеки", "Ветеринарные клиники", "Зоосалоны, зоопарикмахерские", "Зоосалоны", "зоопарикмахерские", "Аптеки", "Автосервисы, автотехцентры", "Автосалоны", "Автозапчасти", "Автомагазины", "Авиа- и ж/д билеты", "Салоны связи", "Строительные магазины", "Военкоматы, комиссариаты", "ЗАГСы", "Налоговые инспекции, службы", "Органы власти", "Отделения милиции", "Паспортно-визовые службы", "Пенсионные фонды", "Религиозные учреждения", "Санэпидемстанции", "Суды", "Судебные приставы", "Центры занятости"]
  CategoryItem.where("parent_id>0").each do |ci|
  #CategoryItem.where("parent_id>0")[0..1].each do |ci|
    key_words = ci.tags.split(",") if ci.tags.present?
    key_words.each do |key_word|
      key_word = (key_word.include?("/")) ? key_word.gsub("/", "-") : key_word
      parse_item key_word, ci
    end
  end
end

def self.parse_item name, cat_item
  ct_address = ContactType.find_or_create_by(name:'address', value:'адрес')
  ct_phone = ContactType.find_or_create_by(name:'phone', value:'тел')

  parsed_json= ""
  path_to_json = Rails.root.join('db', 'scripts', 'json', "#{name}.json")
  puts path_to_json

  if (File.exists?(path_to_json))
    parsed_json = File.open(path_to_json, 'r').read()
  end
  parsed_json = ActiveSupport::JSON.decode(parsed_json)#.load(parsed_json)#.encode(@parsed_json)

  orgs = parsed_json["vpage"]["data"]["businesses"]["GeoObjectCollection"]["features"]#[0]["properties"]["CompanyMetaData"]["name"]
  items = []
  emails = []
  orgs.each do |org|
    #item = org["properties"]["CompanyMetaData"]
    item = org["properties"]["CompanyMetaData"] || org["properties"]["PSearchObjectMetaData"]
    #s = Shop.new
    cname = item["name"].gsub('"', '') if item && item["name"].present?
    caddress = item["address"].gsub(" (Дзæуджыхъæу)", "") if item && item["address"].present?


      if cname.present? && caddress.present? && caddress.split(',').count >= 3
        s = Shop.find_or_create_by(name:cname, address:caddress)
        s.name = cname
        s.address = caddress
        s.www = item["url"] if item && item["url"].present?
        s.email = item["InternalCompanyInfo"]["emails"].join(",") if item.present? && item["InternalCompanyInfo"].present? && item["InternalCompanyInfo"]["emails"].present?
        s.time_work = item["Hours"]["text"] if item && item["Hours"].present? && item["Hours"]["text"].present?
        s.tags += "#{Unicode::downcase(name)}," if s.tags.present?
        s.tags = Unicode::downcase(name) if s.tags.blank?
        #shop = Shop.find_or_initialize_by_name(s.name)
        #if (shop.new_record?)
        #
        #end

        puts "new: #{s.name} | #{s.address} | #{s.email} | #{s.www}"
        phones = item["Phones"] if item && item["Phones"].present?
        if (!phones.blank?)
          phones.each do |phone|
            phone = phone["formatted"]
            if (phone.present?)
              puts "Phone: #{phone}"
              contactItem = ContactItem.find_or_create_by(value:phone, contact_type:ct_phone)
              s.contact_items.append( contactItem )
            end
          end
        end
        s.category_items.append( cat_item )
        s.save!# if s.contact_items.count > 0

        #searchName = s.name
        #shops = Shop.where("name like ? or name like ? or name like ? or name like ?", searchName, Unicode::downcase(searchName), Unicode::upcase(searchName), Unicode::capitalize(searchName))
        #if (shops.blank?)
        #puts "new: #{s.name} | #{shops.count}"
        #else
        #  shops.each do |shop|
        #    puts "finded: #{shop.name} | #{s.name}"
        #    #ci = ContactItem.find_or_create_by(fio:"", department:"", value:address, shop:shop, contact_type:ct_address)
        #    ci = ContactItem.find_or_create_by(value:s.address, contact_type:ct_address)
        #    shop.contact_items << ci if (s.address != shop.address)
        #    shop.contact_items = (shop.contact_items).uniq
        #    #shop.update_attributes(s.attributes.except('id', 'updated_at', 'created_at')) if (!s.name.blank?)
        #    shop.save
        #
        #    s = shop
        #  end
        #end
        items << s
        emails << s.email if s.email.present?

      end
  end
  cat_item.shops = (items+cat_item.shops).uniq()
  puts "emails count = #{emails.count} | emails uniq = #{emails.uniq().count}"
  emails_uniq= emails.uniq()
  puts "emails"
  emails.each do |email|
    puts "#{email},"
  end
  puts "emails uniq"
  emails_uniq.each do |email|
    puts "#{email},"
  end


end

update_shops()
#Shop.dedupe #remove duplicates
