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

  end

  def tcats

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
