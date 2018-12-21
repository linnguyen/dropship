class AddStaticUrlToSpreeAssets < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_assets, :static_url, :string
  end
end
