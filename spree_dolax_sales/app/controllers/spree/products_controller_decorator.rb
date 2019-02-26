Spree::ProductsController.class_eval do
  skip_before_action :verify_authenticity_token

  # Get the Variant from params[:ids], respond with JavaScript
  def get_variant
    @product = Spree::Product.find_by :slug => params[:product_id]
    @variant = @product.find_variant_by_options(params[:ids].split(','))
    respond_to do |format|
      format.json {render json: @variant}
    end
  end

end

