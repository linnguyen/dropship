# This migration comes from spree_dolax_sales (originally 20181220125617)
class AddStaticUrlToSpreeAssets < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_assets, :static_url, :string
  end
end
