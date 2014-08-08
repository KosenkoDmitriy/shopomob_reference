# coding: utf-8
class HomeController < ApplicationController
  before_action :init#, except: [ :index ]

  def parse
    @items=[]
    @html=""
    parsed_json= ""
    path_to_json = Rails.root.join('db', 'scripts', 'json', 'Кинотеатры.json')
    if (File.exists?(path_to_json))
      parsed_json = File.open(path_to_json, 'r').read()
    end
    parsed_json = ActiveSupport::JSON.decode(parsed_json)#.load(parsed_json)#.encode(@parsed_json)

    #count = parsed_json["vpage"]["data"]["businesses"]["GeoObjectCollection"]["features"].count
    #orgs = parsed_json["vpage"]["data"]["businesses"]["GeoObjectCollection"]["features"]#[0]["properties"]["CompanyMetaData"]["name"]

    #@html = count
    #(0..count-1).each do |i|
    #  item = parsed_json["vpage"]["data"]["businesses"]["GeoObjectCollection"]["features"][i]["properties"]["CompanyMetaData"]#["name"]
    #  name = item["name"] if item
    #  @items << name
    #end
    #parsed_json["vpage"]["data"]["businesses"]["GeoObjectCollection"]["features"][0]["properties"]["CompanyMetaData"]["name"]
    orgs = parsed_json["vpage"]["data"]["businesses"]["GeoObjectCollection"]["features"]#[0]["properties"]["CompanyMetaData"]["name"]

    orgs.each do |org|
      #item = org["properties"]["CompanyMetaData"]
      item = org["properties"]["CompanyMetaData"] || org["properties"]["PSearchObjectMetaData"]
      name = item["name"] if item
      address = item["address"] if item
      s = Shop.new
      s.name = name
      s.address = address
      s.www = item["url"] if item
      s.email = item["Phones"][0]["formatted"] if item["Phones"]
      s.time_work = item["Hours"]["text"] if item["Hours"]
      @items <<  s
    end
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
