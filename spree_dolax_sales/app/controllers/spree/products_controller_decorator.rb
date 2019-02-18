module Spree
  module Admin
    ProductsController.class_eval do

      def import
      end

      def bulk_upload
        spreadsheet = Roo::Spreadsheet.open params[:file]
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
          row = Hash[[header, spreadsheet.row(i)].transpose]
          product = Spree::Product.new(
              name: row[" Product_Name"],
              price: row[" Product_Price"],
              description: row[" Product_Description_1"],
              shipping_category_id: 1
          )

          product.save
          # product = find_by(id: row["id"]) || new
          # product.attributes = row.to_hash
          # product.save!
        end
        flash[:notice] = "Products imported!"
        redirect_to import_admin_path
      end

    end
  end
end
