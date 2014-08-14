# coding: utf-8
class HomeController < ApplicationController
  before_action :init#, except: [ :index ]

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
        @shops = Shop.where("name like '#{capitalizeQuery}' or name like '#{upcaseQuery}' or name like '#{downcaseQuery}' or address like '#{capitalizeQuery}' or address like '#{downcaseQuery}' or address like '#{upcaseQuery}' or www like '#{downcaseQuery}' or tags like '#{downcaseQuery}'").order(favorite: :desc, rated: :desc, name: :asc).paginate(:page => params[:page], :per_page => 10)
      else
        upcaseQuery = Unicode::upcase(query)+"%"
        downcaseQuery = Unicode::downcase(query)+"%"
        capitalizeQuery = Unicode::capitalize(query)+"%"
        @shops = Shop.where("name like ? or name like ? or name like ?", upcaseQuery, downcaseQuery, capitalizeQuery).order(favorite: :desc, rated: :desc, name: :asc).paginate(:page => params[:page], :per_page => 10)
      end
    else
      @shops = Shop.order(favorite: :desc, rated: :desc, name: :asc).paginate(:page => params[:page], :per_page => 10) #Shop.all#[0..3]
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

      begin
        @shop = @shops.find( shop_id ) if shop_id > 0
      rescue => ex
        @shop = @shops.first
      end

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

  def serve
    #path = Rails.root.join('public', "#{params[:filename]}.#{params[:extension]}")
    path = Rails.root.join("app", "assets", "#{params[:filename]}.#{params[:extension]}")

    send_file( path,
               :disposition => 'inline',
               #:type => 'application/pdf',
               :type => "application/#{params[:extension]}",
               :x_sendfile => true )
  end

  private
  def is_numeric(o)
    true if Integer(o) rescue false
  end
end
