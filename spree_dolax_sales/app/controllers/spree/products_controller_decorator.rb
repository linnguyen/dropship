module Spree
  ProductsController.class_eval do
    before_action :load_product, only: :show

    # def new
    #   @review = Spree::Review.new(product: @product)
    #   authorize! :create, @review
    # end
    #

    def shipping_return
    end
  end
end
