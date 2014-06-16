class Api::V1::ShopsController < ApplicationController
  def index
    @items = Shop.all
    respond_to do |format|
      format.json { render :json => @items }
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
      format.json { render :json => @item.to_json(include: :contact_items, include: :category_items, include: :categories, include: :images ) }
    end
  end
end
