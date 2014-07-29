class HomeController < ApplicationController
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
    if (params['id'])
      @shop = Shop.find(params['id'])
    end
    if (params['query'])
      query = params['query']
      @shops = Shop.where("name like '#{Unicode::upcase(query)}%' or name like '#{Unicode::downcase(query)}%'").order(favorite: :desc, rated: :desc, name: :asc).paginate(:page => params[:page], :per_page => 10)
    else
      @shops = Shop.paginate(:page => params[:page], :per_page => 10) #Shop.all#[0..3]
    end
    #@shop = @shops.paginate(:page => params[:page], :per_page => 30)

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
end
