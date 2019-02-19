module Spree
  module Admin
    ProductsController.class_eval do
      require 'csv'

      def import
      end

      def bulk_upload
        csv = File.read(params[:file].path)
        CSV.parse(csv, headers: true).each do |row|

        end
        flash[:notice] = "Products imported!"
        redirect_to admin_import_path
        #   https://stackoverflow.com/questions/30395750/ruby-on-rails-4-csv-import-no-implicit-conversion-into-string
      end

    end
  end
end
