def is_phone_exist item
  phones = item["Phones"] if item && item["Phones"].present?
  if (!phones.blank?)
    phones.each do |phone|
      phone = phone["formatted"]
      if (phone.present?)
        return true
      end
    end
  end
  return false
end

def self.update_shops
  #key_words = ["Отдых","развлечения", "Магазины", "Красота", "здоровье", "Услуги", "Спорт","фитнес", "Авто", "Образование", "Туризм", "Недвижимость","строительство", "Финансы", "Транспорт", "Связь", "Домашние животные", "Государство","общество", "Бильярд", "Боулинг", "Дворцы и дома культуры", "Зоопарки", "Кинотеатры", "Музеи", "Ночные клубы", "Парки", "Парки культуры и отдыха", "Развлекательные центры", "Рестораны", "кафе", "бары", "Театры", "Танцы", "Школы танцев", "Гипермаркеты", "Детские магазины", "Книжные магазины", "Компьютерные магазины", "Мебель","Магазины мебели", "одежда", "обувь", "Магазины одежды и обуви", "продукты","Магазины продуктов", "ткань", "Магазины ткани", "хозтовары","Магазины хозтоваров", "электроника","Магазины электроники", "Музыкальные магазины", "Парфюмерные магазины", "Охота","Рыбалка","Охотничьи и рыболовные магазины", "Рынки", "Спортивные магазины", "Супермаркеты", "Торговые центры", "Ювелирные магазины", "Аптеки", "Больницы", "Женские консультации", "Клиники", "Медицинские центры", "Парикмахерские", "Поликлиники", "Родильные дома", "Салоны красоты", "Скорая помощь", "Солярии", "СПА-салоны", "Стоматология", "Травмпункты", "Аварийные службы", "Ателье по пошиву одежды", "Коммунальные службы", "Ломбарды", "Нотариус", "Нотариальные услуги", "Полиграфия", "Полиграфические услуги", "Прачечные", "Такси", "Фотоуслуги", "Химчистки", "Юристы", "Архитектура", "дизайн", "Архитектура и дизайн", "Бани", "сауны", "Бани и сауны", "Бассейны", "Спортивные комплексы", "Стадионы", "Фитнес-клубы", "Автозапчасти", "Автомагазины", "Автомойки", "Автосалоны", "Автосервисы", "автотехцентры", "Автосервисы, автотехцентры","Автостоянки", "Автостоянки, паркинги", "Автошколы", "АЗС", "ГАИ, ГИБДД", "МРЭО", "Шиномонтаж", "Библиотеки", "Вузы", "Детские сады", "Школы", "Авиа- и ж/д билеты", "Авиа билеты", "ж/д билеты", "Гостиницы", "Оформление виз", "Посольства, консульства", "Туроператоры", "Турфирмы", "Агентства недвижимости", "Аренда квартир и офисов", "Двери, дверные блоки", "Окна", "Строительные компании", "Строительные магазины", "Банки", "Банкоматы", "Обмен валют", "Автовокзалы", "Аэропорты", "Железнодорожные вокзалы", "Интернет-кафе", "Операторы сотовой связи", "Почта, телеграф", "Провайдеры", "Салоны связи", "Ветпомощь на дому", "Ветеринарные аптеки", "Ветеринарные клиники", "Зоосалоны, зоопарикмахерские", "Зоосалоны", "зоопарикмахерские", "Аптеки", "Автосервисы, автотехцентры", "Автосалоны", "Автозапчасти", "Автомагазины", "Авиа- и ж/д билеты", "Салоны связи", "Строительные магазины", "Военкоматы, комиссариаты", "ЗАГСы", "Налоговые инспекции, службы", "Органы власти", "Отделения милиции", "Паспортно-визовые службы", "Пенсионные фонды", "Религиозные учреждения", "Санэпидемстанции", "Суды", "Судебные приставы", "Центры занятости"]
  #CategoryItem.where("parent_id>0")[0..5].each do |ci|
  CategoryItem.where("parent_id>0").each do |ci|
    key_words = ci.tags.split(",") if ci.tags.present?
    key_words.each do |key_word|
      key_word = (key_word.include?("/")) ? key_word.gsub("/", "-") : key_word
      parse_item key_word, ci
    end
  end
end

def self.parse_item name, cat_item
  #ct_address = ContactType.find_or_create_by(name:'address', value:'адрес')
  #ct_phone = ContactType.find_or_create_by(name:'phone', value:'тел')
  #ct_url = ContactType.find_or_create_by(name:'url', value:'тел')
  ct_mail = ContactType.find_or_create_by(name:'email', value:'@')
  ct_url = ContactType.find_or_create_by(name:'url', value:'веб-сайт')
  ct_phone = ContactType.find_or_create_by(name:'phone', value:'тел')
  ct_address = ContactType.find_or_create_by(name:'address', value:'адрес')

  parsed_json= ""
  path_to_json = Rails.root.join('db', 'scripts', 'json', "#{name}.json")
  puts path_to_json

  if (File.exists?(path_to_json))
    parsed_json = File.open(path_to_json, 'r').read()
  end
  parsed_json = ActiveSupport::JSON.decode(parsed_json)#.load(parsed_json)#.encode(@parsed_json)

  orgs = parsed_json['vpage']['data']['businesses']['GeoObjectCollection']['features'] if parsed_json.present? && parsed_json['vpage'].present? && parsed_json['vpage']['data'].present? && parsed_json['vpage']['data']['businesses'].present? && parsed_json['vpage']['data']['businesses']['GeoObjectCollection'].present? && parsed_json['vpage']['data']['businesses']['GeoObjectCollection']['features'].present?

  #parsed_json.try("vpage").try("data").try("businesses").try("GeoObjectCollection").try("features") #[0]["properties"]["CompanyMetaData"]["name"]
  #puts "#{parsed_json['vpage']['data']['businesses']['GeoObjectCollection']['features']}\n\n"
  #puts "#{orgs}"
  if orgs.present?
  items = []
  emails = []
  orgs.each do |org|
    #item = org["properties"]["CompanyMetaData"]
    item = org["properties"]["CompanyMetaData"]# || org["properties"]["PSearchObjectMetaData"]
    addressLine = cemail = curl = ""

    if item.present?
      cname = item["name"].gsub('"', '') if item && item["name"].present?
      addressLine = caddress_formatted = item["address"].gsub(" (Дзæуджыхъæу)", "") if item && item["address"].present?

      #caddress_list = caddress_formatted.gsub(" ", "").split(",") if caddress_formatted.present?
      #if caddress_list.present?
      #  ccity = caddress_list[0] if caddress_list.count == 1
      #  cstreet_type = caddress_list[1].split(".")[0] if caddress_list.count == 2
      #  cstreet = caddress_list[1].split(".")[1] if caddress_list.count == 2
      #  chomeno = caddress_list[2] if caddress_list.count == 3
      #end
      #caddress = item["AddressDetails"]["Country"]["AdministrativeArea"]["Locality"] if item && item["AddressDetails"]["Country"].present? && item["AddressDetails"]["Country"].present? && item["AddressDetails"]["Country"]["AdministrativeArea"].present? && item["AddressDetails"]["Country"]["AdministrativeArea"]["Locality"].present?
      #ccity = caddress["LocalityName"].gsub("город", "").gsub(" ", "") if caddress && caddress["LocalityName"].present?
      #cstreet = caddress["Thoroughfare"]["ThoroughfareName"].split(" ").last if caddress && caddress["Thoroughfare"].present? && caddress["Thoroughfare"]["ThoroughfareName"].present?
      #chomeno = caddress["Thoroughfare"]["Premise"]["PremiseNumber"] if caddress && caddress["Thoroughfare"].present? && caddress["Thoroughfare"]["Premise"].present? && caddress["Thoroughfare"]["Premise"]["PremiseNumber"].present?
      #addressLine = "#{ccity}, #{cstreet}, #{chomeno}" if ccity.present? && cstreet.present? && chomeno.present?
      #puts "#{caddress_formatted} | #{caddress_list} | #{addressLine}"

      internal = item["InternalCompanyInfo"] if item && item["InternalCompanyInfo"].present?
      cemail = internal["emails"].join(",") if internal && internal["emails"].present?
      curl = item["url"] if item && item["url"].present?
    else
      item = org["properties"]["PSearchObjectMetaData"]
      cname = item["name"].gsub('"', '') if item && item["name"].present?
      addressLine = caddress_formatted = item["address"].gsub(" (Дзæуджыхъæу)", "") if item && item["address"].present?
      #caddress_list = caddress_formatted.gsub(" ", "").split(",") if caddress_formatted.present?
      #if caddress_list.present?
      #  ccity = caddress_list[0] if caddress_list.count == 1
      #  cstreet_type = caddress_list[1].split(".")[0] if caddress_list.count == 2
      #  cstreet = caddress_list[1].split(".")[1] if caddress_list.count == 2
      #  chomeno = caddress_list[2] if caddress_list.count == 3
      #end

      #caddress = item["Address"] if item && item["Address"].present?
      #ccity = caddress["locality"].gsub(" (Дзæуджыхъæу)", "") if caddress && caddress["locality"].present?
      #ccity = caddress["locality"].split(" ").first if caddress && caddress["locality"].present?
      #cstreet = caddress["thoroughfare"].split(" ").last if caddress && caddress["thoroughfare"].present?
      #chomeno = caddress["premiseNumber"] if caddress && caddress["premiseNumber"].present?
      #addressLine = "#{ccity}, #{cstreet}, #{chomeno}" if ccity.present? && cstreet.present? && chomeno.present?
      #puts "#{caddress_formatted} | #{caddress_list} | #{addressLine}"

      internal = item["internal"] if item && item["internal"].present?
      cphone = internal["phone"] if internal && internal["phone"].present?
      curl = internal["url"] if internal && internal["url"].present?
    end

    if cname.present?
    if ((addressLine.present? && addressLine.split(',').count >= 3) || is_phone_exist(item))
      addressLine = addressLine.gsub(" улица", "").gsub("Улица ", "ул. ").gsub("улица ", "ул. ").gsub("проспект ", "пр. ").gsub("просп. ", "пр. ").gsub("пр-т. ", "пр. ").gsub("переулок ", "пер. ").gsub(" переулок", "")
      addressSplittedLine = addressLine.split(',') if addressLine.present?
      if addressSplittedLine.present?
        addressLine1 = addressSplittedLine[0..-2].join(",").rstrip # before home no
        addressLine2 = addressSplittedLine[-1..-1].join(",").lstrip # home no/last part of address line
        addressLine = addressLine1 + " " + addressLine2
        posCity = addressSplittedLine[-5..-5].join(",").strip if addressSplittedLine[-5..-5].present? #city/town
        posState = addressSplittedLine[-4..-4].join(",").strip if addressSplittedLine[-4..-4].present? #region/area
        posStreet = addressSplittedLine[-3..-3].join(",").strip if addressSplittedLine[-3..-3].present? #region
        posStreet = addressSplittedLine[-2..-2].join(",").strip if addressSplittedLine[-2..-2].present? #region
        posNo = addressSplittedLine[-1..-1].join(",").strip if addressSplittedLine[-1..-1].present? #region
      end
      s = Shop.find_or_create_by(name:cname.strip, address:addressLine.strip)
      s.name = cname
      s.address = addressLine
      s.www = curl # item["url"] if item && item["url"].present?
      s.email = cemail #item["InternalCompanyInfo"]["emails"].join(",") if item.present? && item["InternalCompanyInfo"].present? && item["InternalCompanyInfo"]["emails"].present?
      s.time_work = item["Hours"]["text"] if item && item["Hours"].present? && item["Hours"]["text"].present?
      s.tags += ",#{Unicode::downcase(name)}" if s.tags.present?
      s.tags = "#{Unicode::downcase(name)}" if s.tags.blank?
      s.tags = s.tags.split(",").uniq().join(",")
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
      links = item["Links"] if item && item["Links"].present?
      if (!links.blank?)
        links.each do |link|
          link = link["href"]
          if (link.present?)
            puts "Link: #{link}"
            contactItem = ContactItem.find_or_create_by(value:link, contact_type:ct_url)
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
  else
    puts "\nno companies found!\n #{cat_item.name} | #{name}\n\n"
  end

end

update_shops()
#Shop.dedupe #remove duplicates
