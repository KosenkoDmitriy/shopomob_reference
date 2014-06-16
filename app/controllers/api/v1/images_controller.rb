class Api::V1::ImagesController < ApplicationController
  def show
    @item = Image.find(params['id'])
    respond_to do |format|
      format.json { render :json => @item }
    end
  end
end
