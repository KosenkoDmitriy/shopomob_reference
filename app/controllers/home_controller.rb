class HomeController < ApplicationController
  #after_action :set_csrf_headers, only: :create
  token = "x37DrAAwyIIb7s+w2+AdoCR8cAJIpQhIetKRrPgG5VA="
  #before_action :authenticate, except: [ :index ]
  protect_from_forgery with: :exception

  def index2
    #render_navigation#(level:0)
  end

  def index

  end

  def services

  end

  def contacts

  end

  def shops

  end

  def shops
    squery = params[:q]
    query = params[:query]

    if (params[:page].blank?)
      params[:page] = "1"
    end

    if (params[:id])
      @shop = Shop.find(params['id'])
    end

    if (!query.blank?)
      upcaseQuery = Unicode::upcase(query)+"%"
      downcaseQuery = Unicode::downcase(query)+"%"
      capitalizeQuery = "%" + Unicode::capitalize(query)+"%"
      @shops = Shop.where("name like ? or name like ? or address like ? or www like ? or tags like '%#{downcaseQuery}'", upcaseQuery, downcaseQuery, capitalizeQuery, downcaseQuery).order(favorite: :desc, rated: :desc, name: :asc).paginate(:page => params[:page], :per_page => 10)
    elsif (!squery.blank?)
      upcaseQuery = Unicode::upcase(squery)+"%"
      downcaseQuery = Unicode::downcase(squery)+"%"
      @shops = Shop.where("name like ? or name like ?", upcaseQuery, downcaseQuery).order(favorite: :desc, rated: :desc, name: :asc).paginate(:page => params[:page], :per_page => 10)
    else
      @shops = Shop.paginate(:page => params[:page], :per_page => 10) #Shop.all#[0..3]
    end
  end

  def cats
    cid = params['id'].to_i
    shop_id = params[:shop_id].to_i
    if (shop_id > 0)
      @shop = Shop.find(shop_id)
    end
    if (cid > 0)
      @item = Category.find(cid)
      #@shops = Category.find(cid).shops.order(favorite: :desc, rated: :desc, name: :asc)
    end
    @items = Category.all
  end

  def tcats
    tcid = params[:id].to_i
    shop_id = params[:shop_id].to_i
    if (shop_id > 0)
      @shop = Shop.find(shop_id)
    end
    if (tcid > 0)
      @item = CategoryItem.find(tcid)
      #@shops = CategoryItem.find(tcid).shops.order(favorite: :desc, rated: :desc, name: :asc)
    end
    @items = CategoryItem.all
  end

  def services_sms

  end

  def services_rent_shop

  end

  def services_rent_app

  end

  def services_adv

  end

  private
  def authenticate

  end
end
