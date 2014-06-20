class Api::V1::CategoryController < ApplicationController

  def index
    if params['parent_id']
      @items = Category.where(parent_id: params['parent_id'].to_i).all
    else
      @items = Category.joins(:shops).order(name: :asc).distinct(:name)
    end
    respond_to do |format|
      #format.json { render :json => @items }
      format.json { render :json => @items.to_json(include: {:image => {:only => [:image_file_name], :methods => [:image_url]}}, :only => [:id, :name, :parent_id] )}
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
