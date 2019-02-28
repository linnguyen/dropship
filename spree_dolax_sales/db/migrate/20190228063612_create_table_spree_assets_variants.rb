class CreateTableSpreeAssetsVariants < ActiveRecord::Migration[5.2]
  def change
    create_table :spree_assets_variants, id: false do |t|
      t.references :asset, index: true
      t.references :variant, index: true
    end
  end
end
