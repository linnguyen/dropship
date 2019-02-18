module Spree
  module Admin
    ProductsController.class_eval do
      require 'csv'

      def import
      end

      def bulk_upload
        # spreadsheet = Roo::Spreadsheet.open params[:file]
        # header = spreadsheet.row(1)
        # (2..spreadsheet.last_row).each do |i|
        #   row = Hash[[header, spreadsheet.row(i)].transpose]
        #   product = Spree::Product.new(
        #       name: row[" Product_Name"],
        #       price: row[" Product_Price"],
        #       description: row[" Product_Description_1"],
        #       shipping_category_id: 1
        #   )
        #
        #   product.save
        #   # product = find_by(id: row["id"]) || new
        #   # product.attributes = row.to_hash
        #   # product.save!
        # end
        csv = File.read(params[:file].path)
        CSV.parse(csv, headers: true).each do |row|
          logger.info row
           byebug
        end
        flash[:notice] = "Products imported!"
        redirect_to import_admin_path
      #   https://stackoverflow.com/questions/30395750/ruby-on-rails-4-csv-import-no-implicit-conversion-into-string
      end

    end
  end
end
