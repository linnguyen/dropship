class AddLastNameToSpreeUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_users, :last_name, :string
  end
end
