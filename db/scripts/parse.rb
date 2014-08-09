# load './db/scripts/parse.rb'
require "net/http"
require "uri"

url = "http://maps.yandex.ru" #"http://localhost:3000/api/v1/t_category"#"http://google.com/"
uri = URI.parse(url)
headers = {
    #"User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36",
    "User-Agent" => "User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:2.0.1) Gecko/20100101 Firefox/4.0.1",
    "Accept" => "*/*",
    "Accept-Language"=>"en-US,en;q=0.8,ru;q=0.6",
    "Accept-Encoding"=>"gzip,deflate,sdch",
    "Connection"=>"keep-alive",
    #"Content-Type"=>"content=application/json; charset=cp-1251;",
}

http = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri)

response = http.request(request)

keys = response.body.scan(/'(secret-key)':'(\w+\d+)'/) #scan("/'secret-key':'(.+)'/Ui")
key = keys[0][1] if !keys.blank?

puts "response code:" + response.code             # => 301
puts "body:" + response.body             # => The body (HTML, XML, blob, whatever)
# Headers are lowercased
puts "cache:" + response["cache-control"] # => public, max-age=2592000
puts "keys: #{keys}"
puts "key: #{key}"

@cookie = response.response['set-cookie']
puts "cookie: #{@cookie}"

if (!key.blank?)
  puts "\n\n--parsing--\n"
  #key_words = ["Отдых","развлечения", "Магазины", "Красота", "здоровье", "Услуги", "Спорт","фитнес", "Авто", "Образование", "Туризм", "Недвижимость","строительство", "Финансы", "Транспорт", "Связь", "Домашние животные", "Государство","общество", "Бильярд", "Боулинг", "Дворцы и дома культуры", "Зоопарки", "Кинотеатры", "Музеи", "Ночные клубы", "Парки", "Парки культуры и отдыха", "Развлекательные центры", "Рестораны", "кафе", "бары", "Театры", "Танцы", "Школы танцев", "Гипермаркеты", "Детские магазины", "Книжные магазины", "Компьютерные магазины", "Мебель","Магазины мебели", "одежда", "обувь", "Магазины одежды и обуви", "продукты","Магазины продуктов", "ткань", "Магазины ткани", "хозтовары","Магазины хозтоваров", "электроника","Магазины электроники", "Музыкальные магазины", "Парфюмерные магазины", "Охота","Рыбалка","Охотничьи и рыболовные магазины", "Рынки", "Спортивные магазины", "Супермаркеты", "Торговые центры", "Ювелирные магазины", "Аптеки", "Больницы", "Женские консультации", "Клиники", "Медицинские центры", "Парикмахерские", "Поликлиники", "Родильные дома", "Салоны красоты", "Скорая помощь", "Солярии", "СПА-салоны", "Стоматология", "Травмпункты", "Аварийные службы", "Ателье по пошиву одежды", "Коммунальные службы", "Ломбарды", "Нотариус", "Нотариальные услуги", "Полиграфия", "Полиграфические услуги", "Прачечные", "Такси", "Фотоуслуги", "Химчистки", "Юристы", "Архитектура", "дизайн", "Архитектура и дизайн", "Бани", "сауны", "Бани и сауны", "Бассейны", "Спортивные комплексы", "Стадионы", "Фитнес-клубы", "Автозапчасти", "Автомагазины", "Автомойки", "Автосалоны", "Автосервисы", "автотехцентры", "Автосервисы, автотехцентры","Автостоянки", "Автостоянки, паркинги", "Автошколы", "АЗС", "ГАИ, ГИБДД", "МРЭО", "Шиномонтаж", "Библиотеки", "Вузы", "Детские сады", "Школы", "Авиа- и ж/д билеты", "Авиа билеты", "ж/д билеты", "Гостиницы", "Оформление виз", "Посольства, консульства", "Туроператоры", "Турфирмы", "Агентства недвижимости", "Аренда квартир и офисов", "Двери, дверные блоки", "Окна", "Строительные компании", "Строительные магазины", "Банки", "Банкоматы", "Обмен валют", "Автовокзалы", "Аэропорты", "Железнодорожные вокзалы", "Интернет-кафе", "Операторы сотовой связи", "Почта, телеграф", "Провайдеры", "Салоны связи", "Ветпомощь на дому", "Ветеринарные аптеки", "Ветеринарные клиники", "Зоосалоны, зоопарикмахерские", "Зоосалоны", "зоопарикмахерские", "Аптеки", "Автосервисы, автотехцентры", "Автосалоны", "Автозапчасти", "Автомагазины", "Авиа- и ж/д билеты", "Салоны связи", "Строительные магазины", "Военкоматы, комиссариаты", "ЗАГСы", "Налоговые инспекции, службы", "Органы власти", "Отделения милиции", "Паспортно-визовые службы", "Пенсионные фонды", "Религиозные учреждения", "Санэпидемстанции", "Суды", "Судебные приставы", "Центры занятости"]
  key_words = []
  tcats = CategoryItem.where("parent_id>=0").select('tags')
  tcats.each do |tcat|
    tcat_array = tcat.tags.split(",")
    tcat_array.each do |tcat_item|
      key_words << tcat_item
    end
  end
  puts "key_words: #{key_words}"

  key_words.each do |key_word|
    key_word_escaped = URI.escape(key_word)
    results = 1000
    url = "http://maps.yandex.ru/?text=#{key_word_escaped}&sll=44.680171999999985,43.01867800002452&sspn=1.0848999023437322,0.16951489115989204&source=catalog&results=#{results}&key=#{key}&output=json"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    json_headers = {
        "Content-Type"=>"application/json; charset=utf-8",
        "Cookie" => @cookie
    }
    request = Net::HTTP::Get.new(uri.request_uri, json_headers)
    response = http.request(request)
    document_encoding = response['content-type']

    puts "body:" + response.body             # => The body (HTML, XML, blob, whatever)
    # Headers are lowercased
    puts "cache:" + response["cache-control"] # => public, max-age=2592000
    puts "document_encoding:" + document_encoding
    puts "url:" + url
    puts "response code:" + response.code             # => 301

    parsed_json = ActiveSupport::JSON.decode(response.body)

    #json_path = Rails.root.join("db", "scripts", "json", "#{key_word}.json").to_s #File.dirname(__FILE__)+"/db/scripts/json/#{key_word}.json"
    json_path = File.dirname(__FILE__)+"/json/#{key_word.gsub("/","-")}.json"
    File.open(json_path,"w") do |f|
      f.write(parsed_json.to_json)
      puts "write to: "+json_path + "\n\n"
    end
  end
end

