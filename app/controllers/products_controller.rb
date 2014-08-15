class ProductsController < ApplicationController
autocomplete :brand, :name, :full => true
  def index
    @products = Product.all
    @brands = Brand.all
  end
  def show
    @product = Product.first
    @brand = Brand.first
  end
end
