Spree::ProductsHelper.module_eval do
  # This function only applied for $, if another currency will be changed later
   def price_before_discount(product)
       (product.price + product.price * 0.45).round(2)
   end
end