Spree::ProductsHelper.module_eval do
  # This function only applied for $, if another currency will be changed later
   def price_before_discount(product)
       (product.price + product.price * 0.45).round(2)
   end

  # This function is randomly for displaying discount percent, for the future will have a field in Database for percent discount, now just
  # get it from helper class
  def display_discount
    [true, false].sample
  end
end