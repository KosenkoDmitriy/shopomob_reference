# coding: utf-8
class HomeController < ApplicationController
  before_action :init#, except: [ :index ]

  def parse
    #require 'rubygems'
    #require 'nokogiri'
    #require 'open-uri'
    require 'uri'
    require 'net/http'

    #@items = Service.all
    # Get a Nokogiri::HTML::Document for the page we’re interested in...

    #doc = Nokogiri::HTML(open('http://www.google.com/search?q=sparklemotion'))

    # Do funky things with it using Nokogiri::XML::Node methods...

    @items = []
    ####
    # Search for nodes by css
    #doc.css('h3.r a').each do |link|
    #  puts link.content
    #end

    ####
    # Search for nodes by xpath
    #doc.xpath('//h3/a').each do |link|
    #  puts link.content
    #end

    ####
    # Or mix and match.
    #doc.search('h3.r a.l', '//h3/a').each do |link|
    #  #puts link.content
    #  @items << link.content.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    #end

    #orgs = Nokogiri::HTML(open('http://maps.yandex.ru/?text=%D0%9A%D0%B8%D0%BD%D0%BE%D1%82%D0%B5%D0%B0%D1%82%D1%80%D1%8B&sll=44.680172%2C43.018678&sspn=0.122764%2C0.137934&z=13&results=20&ll=44.669222%2C43.031141&spn=0.161362%2C0.065485&l=map'))
    #orgs.css('div.b-serp-item__title').each do |link|
    #  #puts link.content
    #  @items << link #.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    #end
    #url = 'http://maps.yandex.ru/?text=%D0%9A%D0%B8%D0%BD%D0%BE%D1%82%D0%B5%D0%B0%D1%82%D1%80%D1%8B&sll=44.680172%2C43.018678&sspn=0.122764%2C0.137934&z=13&results=20&ll=44.669222%2C43.031141&spn=0.161362%2C0.040676&l=map'
    #url = 'http://maps.yandex.ru/?text=Кинотеатры&sll=44.680172%2C43.018678&sspn=0.122764%2C0.137934&z=13&results=20&ll=44.669222%2C43.031141&spn=0.161362%2C0.040676&l=map&key=uee5532edbc87aff9007e225725db6455'
    #url = URI.escape(url)
#    Accept:text/plain, */*; q=0.01
#Accept-Encoding:gzip,deflate,sdch
#Accept-Language:en-US,en;q=0.8,ru;q=0.6
#Connection:keep-alive
#Cookie:yandexuid=1256109401363551873; fuid01=514c2f9d7f6d2994.T-Ll-PKKKZVQxeOGIQRm_gHpUDXmpKCU_cqRygteQ79TBzz-iLUBry-OxkDzVDkjAzTlKPH5XYGF1MZ3QM0u-r0htwuN0CofkhLRKjKHRyUNlMsZFZqyHx7kYQREVRrH; trfe=on; yandex_login=bond-007-89@mail.ru; my=YwA=; L=ZHEtMkdCdFsAVGFVT0dQfwBeWWZzaGZjJk4CJyskcggdCC4ZABI2HxQLFXJZAmN/CggbNB8+ShkFJjxGJAwBfw==.1400133248.10446.263822.0864c57c0273fc504578698eb28ae185; yandex_gid=33; maps-filters-hint=true; yp=1715493248.udn.Ym9uZC0wMDctODlAbWFpbC5ydQ==#2147483647.ygo.26:33; ys=wprid.1407011480710072-645379654683999666008993-ws39-831; yabs-frequency=/4/0000000000000000/qmElS3WQ9z83ht0u6Yu0/; Session_id=2:1407434743.0.5.*89675887.8:1400133248012:1603906295:16.0.1.1.0.114775.130741.adacaa749947745974966f5c6a29b171
#        Host:maps.yandex.ru
#    Referer:http://maps.yandex.ru/?text=%D0%BA%D0%B8%D0%BD%D0%BE%D1%82%D0%B5%D0%B0%D1%82%D1%80%D1%8B&sll=44.680172%2C43.018678&sspn=0.122764%2C0.137934&z=13&results=20&ll=44.669222%2C43.031141&spn=0.161362%2C0.021912&l=map
#    User-Agent:Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36
#    X-Requested-With:XMLHttpRequest

    #h1 = open(url,
    #          #"User-Agent" => "Mozilla/5.0 (Windows NT 6.1; rv:2.0.1) Gecko/20100101 Firefox/4.0.1",
    #          "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36",
    #             "Accept" => "*/*",
    #             "Accept-Language"=>"en-US,en;q=0.8,ru;q=0.6",
    #             "Accept-Encoding"=>"gzip, deflate,sdch",
    #             "Connection"=>"keep-alive")
    #
    #
    #
    #doc = Nokogiri::HTML(h1)
    ##doc = JSON.parse(h1)
    #doc.encoding = 'utf-8'
    #
    #@html = doc.to_html#doc.to_html#css("div#r-business")#.to_html
    #@items = doc.css("#r-business").map do| div |
    #  div.to_html
    #end

    #@items = doc.css("a.b-link.b-link_pseudo_yes.b-link_theme_light.b-serp-item__title-link.b-c.b-c_click_yes.b-c_show_yes.b-c_path_title.i-bem.b-c_js_inited").map do |link|
    #  if (href = link.attr("href")) && !href.empty?
    #    URI::join(url, href)
    #  end
    #end#.compact.uniq

    #response = http.send_request('GET', '/index.html')
    #puts response.body

    body = send_request 'http://maps.yandex.ru' # 'http://ref.shopomob.ru'#
    keys = body.scan(/'(secret-key)':'(\w+\d+)'/) #scan("/'secret-key':'(.+)'/Ui")
    key = keys[0][1] if !keys.blank?

    url =  "http://maps.yandex.ru/?text=Кинотеатры&sll=44.680172%2C43.018678&sspn=0.122764%2C0.137934&z=13&results=20&ll=44.669222%2C43.031141&spn=0.161362%2C0.040676&l=map&key=#{key}&output=json" #"http://ref.shopomob.ru/api/v1/t_category.json" #
    url = URI.escape(url)
    uri = URI.parse(url)
    conn = Net::HTTP.start(uri.host, uri.port)
    #resp, data = conn.send_request('GET', uri.request_uri)
    response, data = conn.get(url, {
        #"User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36",
        "User-Agent" => "User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:2.0.1) Gecko/20100101 Firefox/4.0.1",
        "Accept" => "*/*",
        "Accept-Language"=>"en-US,en;q=0.8,ru;q=0.6",
        "Accept-Encoding"=>"gzip,deflate,sdch",
        "Connection"=>"keep-alive",
        "Content-Type"=>"application/json;charset=UTF-8",
        #"Content-Type"=>"content=application/json; charset=cp-1251;",
        "Cookie" => @cookie
    })
    #resp3 = open(url,
    #             #"User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36",
    #             "User-Agent" => "User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:2.0.1) Gecko/20100101 Firefox/4.0.1",
    #             "Accept" => "*/*",
    #             "Accept-Language"=>"en-US,en;q=0.8,ru;q=0.6",
    #             "Accept-Encoding"=>"gzip,deflate,sdch",
    #             "Connection"=>"keep-alive",
    #             #"Content-Type"=>"content=application/json; charset=cp-1251;",
    #             "Cookie" => @cookie)
    #resp = resp3.read
    #resp, data = conn.post(url,body, )
    #document_encoding = resp2['content-type']
    #@html = res.force_encoding('UTF-8')#res.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    #@html1 = resp2.body.encode!('ASCII-8BIT', 'binary', invalid: :replace, undef: :replace, replace: '')
    #@html = resp2.body.force_encoding('utf-8')#.encode('utf-8'),nil, 'utf-8')
    #@html7 = resp2.body.force_encoding('ASCII-8BIT')#.encode('utf-8'),nil, 'utf-8')
    ##@html8 = resp2.body.force_encoding('windows-1251')#.encode('utf-8'),nil, 'utf-8')
    #@html2 = resp2.body.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    #@html4 = resp2.body.encode!('windows-1251')#, 'binary', invalid: :replace, undef: :replace, replace: '')
    #@html5 = resp2.body.encode!('ASCII-8BIT')#, 'binary', invalid: :replace, undef: :replace, replace: '')
    #@html6 = resp2.body.encode!('windows-1251')#, 'binary', invalid: :replace, undef: :replace, replace: '')
    begin
      cleaned = response.body.dup.force_encoding('UTF-8')
      unless cleaned.valid_encoding?
        cleaned = response.body.encode( 'UTF-8', 'Windows-1251' )
      end
      content = cleaned
    rescue EncodingError
      content.encode!( 'UTF-8', invalid: :replace, undef: :replace )
    end
    @html = content || "empty"
  end

  def parse_json
    #http://localhost:3000/api/v1/t_category

  end

  def send_request url
    # Create a new connection object.
    uri = URI.parse(url)
    conn = Net::HTTP.start(uri.host, uri.port)
    body = ''
    # Get the response when we login, to set the cookie.
    # body is the encoded arguments to log in.
    resp, data = conn.send_request('GET', uri.request_uri)
    @cookie = resp.response['set-cookie']

    #response, data = Net::HTTP::Post.new(uri.request_uri, "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36",
    #         "Accept" => "*/*",
    #         "Accept-Language"=>"en-US,en;q=0.8,ru;q=0.6",
    #         "Accept-Encoding"=>"gzip, deflate,sdch",
    #         "Connection"=>"keep-alive",
    #         "Content-Type"=>"content=text/html; charset=utf-8;",
    #         "Cookie" => @cookie
    #
    #        )
    #resp, data = conn.post(url)
    #response2 = conn.request(response)
    #@cookie = cookie

    # Headers need to be in a hash.
    #headers = {
    #    #"User-Agent" => "Mozilla/5.0 (Windows NT 6.1; rv:2.0.1) Gecko/20100101 Firefox/4.0.1",
    #    "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36",
    #    "Accept" => "*/*",
    #    "Accept-Language"=>"en-US,en;q=0.8,ru;q=0.6",
    #    "Accept-Encoding"=>"gzip, deflate,sdch",
    #    "Connection"=>"keep-alive",
    #    "Cookie" => cookie,
    #    "Content-Type"=>"content=text/html; charset=utf-8;",
    #}

    # On a get, we don't need a body.
    #response, data = conn.post(url, body, headers)
    return resp.body

    #begin
    #  cleaned = response.body.dup.force_encoding('UTF-8')
    #  unless cleaned.valid_encoding?
    #    cleaned = response.body.encode( 'UTF-8', 'Windows-1252' )
    #  end
    #  content = cleaned
    #rescue EncodingError
    #    content.encode!( 'UTF-8', invalid: :replace, undef: :replace, replace: '' )
    #    # Force it to UTF-8, throwing out invalid bits
    #  #content = content.force_encoding("ISO-8859-1").encode("utf-8", replace: nil) if content
    #end
    #return content
  end

  def init
    @banners = Banner.all#[0..25]
  end

  def index

  end

  def services
    @services = Service.all.order(order_id: :asc, title: :asc)
  end

  def shops
    @alphabet = ['А','Б', 'В', 'Г', 'Д', 'Е', 'Ж', 'З', 'И', 'К', 'Л', 'М', 'Н', 'О', 'П', 'Р', 'С', 'Т', 'У', 'Ф', 'Х', 'Ц', 'Ч', 'Ш', 'Щ', 'Ы', 'Э', 'Ю', 'Я',
             '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']

    query = params[:search]  #if search by letter or number
    #squery = (!query.blank? && query.size > 2) ? query : ""

    if (params[:page].blank?)
      params[:page] = "1"
    end
    #
    if (!query.blank?)
      if (is_numeric(query)) #if searching by number or letter
        queryString = "name like '#{query}%' or name like '%#{query}%'"
        @shops = Shop.where(queryString).order(favorite: :desc, rated: :desc, name: :asc).paginate(:page => params[:page], :per_page => 10)
      elsif (query.size > 2) # searching by not name only
        upcaseQuery = "%" + Unicode::upcase(query)+"%"
        downcaseQuery = "%" + Unicode::downcase(query)+"%"
        capitalizeQuery = "%" + Unicode::capitalize(query)+"%"
        address = "%" + Unicode::downcase(query)+"%"
        @shops = Shop.where("name like '#{upcaseQuery}' or name like '#{downcaseQuery}' or address like '#{capitalizeQuery}' or address like '#{downcaseQuery}' or address like '#{upcaseQuery}' or www like '#{downcaseQuery}' or tags like '#{downcaseQuery}'").order(favorite: :desc, rated: :desc, name: :asc).paginate(:page => params[:page], :per_page => 10)
      else
        upcaseQuery = Unicode::upcase(query)+"%"
        downcaseQuery = Unicode::downcase(query)+"%"
        @shops = Shop.where("name like ? or name like ?", upcaseQuery, downcaseQuery).order(favorite: :desc, rated: :desc, name: :asc).paginate(:page => params[:page], :per_page => 10)

      end
    else
      @shops = Shop.paginate(:page => params[:page], :per_page => 10) #Shop.all#[0..3]
    end

    if (params[:id].to_i>0)
      @shop = Shop.find(params['id'])
    elsif (!@shops.blank?)
      @shop = @shops.first
    end

    #redirect_to shops_path + "/#{@shop.id}?query=#{squery}&page=#{params[:page] }"

  end

  #def search_shops
  #
  #end

  def cats
    #cid = params['id'].to_i
    #shop_id = params[:shop_id].to_i
    #if (shop_id > 0)
    #  @shop = Shop.find(shop_id)
    #end
    #if (cid > 0)
    #  @item = Category.find(cid)
    #  #@shops = Category.find(cid).shops.order(favorite: :desc, rated: :desc, name: :asc)
    ##else
    #end
    #@items = Category.where(parent_id:0).order(name: :asc)#.paginate(:page => params[:page], :per_page => 10) #Shop.all#[0..3]
    tcid = params[:id].to_i
    shop_id = params[:shop_id].to_i

    @items = Category.all.order(name: :asc)#.where(parent_id:0).order(name: :asc)#.paginate(:page => params[:page], :per_page => 10) #Shop.all#[0..3]
    if (@items.count>0)
      tsubid = (tcid > 0) ? tcid : @items.first.id
      #if (Category.where(parent_id:tsubid).count > 0)
      #  @sub_items = Category.where(parent_id:tsubid).order(name: :asc)
      @shops = Category.find(tsubid).shops.order(favorite: :desc, rated: :desc, name: :asc).paginate(:page => params[:page], :per_page => 10)
      if (@shops.count > 0 && shop_id <= 0)
        @shop = @shops.first
      elsif (shop_id > 0)
        @shop = Shop.find(shop_id)
      end
    end
  end

  def tcats

    tcid = params[:id].to_i
    shop_id = params[:shop_id].to_i

    #@tcats = CategoryItem.where(parent_id:0).order(name: :asc)#.paginate(:page => params[:page], :per_page => 10) #Shop.all#[0..3]
    @tcats = CategoryItem.all.order(name: :asc)
    if (!@tcats.blank?)
      tcid = (tcid > 0) ? tcid : @tcats.first.id if @tcats.first
      shop_id = (shop_id > 0) ? shop_id : @tcats.first.shops.first.id if @tcats.first.shops.first

      @shops = @tcats.find( tcid ).shops.order(favorite: :desc, rated: :desc, name: :asc).paginate(:page => params[:page], :per_page => 10)
      @shop = @shops.find( shop_id ) if shop_id > 0
    end
    #@shop = Shop.find( shop_id )
    #@shops = CategoryItem.find( shop_id ).shops.order(favorite: :desc, rated: :desc, name: :asc).paginate(:page => params[:page], :per_page => 10)

    #@items = CategoryItem.where(parent_id:0).order(name: :asc)#.paginate(:page => params[:page], :per_page => 10) #Shop.all#[0..3]
    #@sub_items = CategoryItem.all.order(name: :asc)
    #
    #if (@items.count>0)
    #  tsubid = (tcid > 0) ? tcid : @items.first.id
    #  if (@items.where(parent_id:tsubid).count > 0)
    #    #@sub_items = CategoryItem.where(parent_id:tsubid).order(name: :asc)
    #    @shops = CategoryItem.find(tsubid).shops.order(favorite: :desc, rated: :desc, name: :asc).paginate(:page => params[:page], :per_page => 10)
    #    if (@shops.count > 0 && shop_id <= 0)
    #      @shop = @shops.first
    #    elsif (shop_id > 0)
    #      @shop = Shop.find(shop_id)
    #    end
    #  end
    #else

    #end

  end

  private
  def is_numeric(o)
    true if Integer(o) rescue false
  end
end
