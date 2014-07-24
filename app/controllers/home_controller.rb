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
    @shops = Shop.all#[0..3]
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
