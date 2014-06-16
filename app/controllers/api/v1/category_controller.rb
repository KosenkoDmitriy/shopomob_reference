class Api::V1::CategoryController < ApplicationController

  def index
    if params['parent_id']
      @items = Category.where(parent_id: params['parent_id'].to_i).all
    else
      @items = Category.all
    end
    respond_to do |format|
      format.json { render :json => @items }
    end
  end

  def show
    @item = Category.find(params['id'])
    respond_to do |format|
      format.json { render :json => @item }
    end
  end

  #def id
  #  @item = Category.find(params['id'])
  #  respond_to do |format|
  #    format.json { render :json => @item }
  #  end
  #end

end
