# frozen_string_literal: true

class ProductsController < AuthenticatedController
  def index
    @products = PrivateShop.find(params[:id]).get_products(limit= 10)
    render(json: { products: @products })
  end

  def create
    @product = PrivateShop.find(params[:id]).create_product(products_param)
    render(json: { product: @product })
  end
end
