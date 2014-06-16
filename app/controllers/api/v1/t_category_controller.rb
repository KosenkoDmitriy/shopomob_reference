class Api::V1::TCategoryController < ApplicationController
  def index

    if params['parent_id']
      @items = CategoryItem.where(parent_id: params['parent_id'].to_i)
    else
      @items = CategoryItem.all
    end
    respond_to do |format|
      format.json { render :json => @items }
    end
  end

  def show
    @item = CategoryItem.find(params['id'])
    respond_to do |format|
      format.json { render :json => @item }
    end
  end
end
