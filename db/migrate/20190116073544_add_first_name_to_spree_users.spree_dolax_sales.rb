# This migration comes from spree_dolax_sales (originally 20190116072816)
class AddFirstNameToSpreeUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_users, :first_name, :string
  end
end
