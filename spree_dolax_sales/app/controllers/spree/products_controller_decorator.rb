module Spree
  ProductsController.class_eval do

    # Get the Variant from params[:ids], respond with JavaScript
    def get_variant
      @product = Spree::Product.find_by :slug => params[:product_id]
      @variant = @product.find_variant_by_options(params[:ids].split(','))

      respond_to do |format|
        format.js
      end
    end

  end
end
