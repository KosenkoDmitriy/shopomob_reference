class Api::V1::ShopsController < ApplicationController
  def index
    cid = params['category_id']
    if (cid)
      @items = Category.find(cid.to_i).shops.order(favorite: :desc, rated: :desc, name: :asc)
    else
      #@items = Shop.all.order_by()#[0..3]
      @items = Shop.order(favorite: :desc, rated: :desc, name: :asc)
    end
    respond_to do |format|
      format.json { render :json => @items } #.to_json(include: :contact_items) }
    end

  end

  def show
    @item = Shop.find(params['id'])
    #@item.c = Shop.find(params['id'])
    #@image = Image.first
    #@item.images.append(@image)
    #@item.build
    #respond_with @item

    respond_to do |format|
      #format.json { render :json => @item.to_json(include: [:contact_items, :categories, :category_items, :images]) }#.to_json(include: :category_items) } #, include: :category_items, include: :categories, include: :images ) }
      #format.json { render :json => @item.to_json(include: [{categories: {include: :category_items}}, contact_items: {include: :contact_type}] )}
      format.json { render :json => @item.to_json(include: [:contact_items => {include: [:contact_type => {:only => [:name]}], :only => [:department, :value]}] )}
    end
  end
end
