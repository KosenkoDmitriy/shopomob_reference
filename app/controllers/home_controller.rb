class HomeController < ApplicationController
  before_action :init#, except: [ :index ]

  def init
    @banners = Banner.all
  end

  def index

  end

  def services
    @services = Service.all.order(order_id: :asc, title: :asc)
  end

  def shops
    squery = params[:squery]
    query = params[:query]

    if (params[:page].blank?)
      params[:page] = "1"
    end

    if (!query.blank?)
      if (query.to_i >= 0)
        #query = "%"+query+"%"
        #queries = [1,2,3,4,5,6,7,8,9,'-', '+', '_']
        #queryString = "name like ''%#{queries.first}%''"
        #queries[1..queries.count].each do |item|
        #  queryString += " or name like ''%#{item}%''"
        #end
        queryString = "name like '#{query}%' or name like '%#{query}%'"
        @shops = Shop.where(queryString).order(favorite: :desc, rated: :desc, name: :asc).paginate(:page => params[:page], :per_page => 10)
      else
        upcaseQuery = Unicode::upcase(query)+"%"
        downcaseQuery = Unicode::downcase(query)+"%"
        @shops = Shop.where("name like ? or name like ?", upcaseQuery, downcaseQuery).order(favorite: :desc, rated: :desc, name: :asc).paginate(:page => params[:page], :per_page => 10)
      end
      elsif (!squery.blank?)
      upcaseQuery = Unicode::upcase(squery)+"%"
      downcaseQuery = Unicode::downcase(squery)+"%"
      capitalizeQuery = "%" + Unicode::capitalize(squery)+"%"
      @shops = Shop.where("name like ? or name like ? or address like ? or www like ? or tags like '%#{downcaseQuery}'", upcaseQuery, downcaseQuery, capitalizeQuery, downcaseQuery).order(favorite: :desc, rated: :desc, name: :asc).paginate(:page => params[:page], :per_page => 10)
    else
      @shops = Shop.paginate(:page => params[:page], :per_page => 10) #Shop.all#[0..3]
    end

    if (params[:id])
      @shop = Shop.find(params['id'])
    elsif (!@shops.blank?)
      @shop = @shops.first
    end
  end

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

    tcid = (tcid > 0) ? tcid : @tcats.first.id
    shop_id = (shop_id > 0) ? shop_id : @tcats.first.shops.first

    @shops = @tcats.find( tcid ).shops.order(favorite: :desc, rated: :desc, name: :asc).paginate(:page => params[:page], :per_page => 10)
    @shop = @shops.find( shop_id )
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
  def authenticate

  end
end
