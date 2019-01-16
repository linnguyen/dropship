# This migration comes from spree_dolax_sales (originally 20190116074010)
class AddLastNameToSpreeUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_users, :last_name, :string
  end
end
