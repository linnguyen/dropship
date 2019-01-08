module Spree
  module ProductsHelper
    ProductsHelper.module_eval do
      def related_product(product)
        products = Spree::Product.in_taxons(product.taxon_id)
      end
    end
  end
end