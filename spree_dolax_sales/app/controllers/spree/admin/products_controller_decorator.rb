module Spree
  ProductsController.class_eval do
    before_action :load_product, only: :show

  end
end
