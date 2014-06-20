class Api::V1::TCategoryController < ApplicationController
  def index
    if params['parent_id']
      @items = CategoryItem.where(parent_id: params['parent_id'].to_i).order(:name)
    else
      @items = CategoryItem.order(:name)
    end
    respond_to do |format|
      format.json { render :json => @items.to_json(include: {:image => {:only => [:image_file_name], :methods => [:image_url]}}, :only => [:id, :name, :parent_id] )}
    end
  end

  def show
    @item = CategoryItem.find(params['id'])
    respond_to do |format|
      format.json { render :json => @item }
    end
  end
end
