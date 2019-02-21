Spree::Admin::ProductsController.class_eval do
  require 'csv'

  def import
  end

  def bulk_upload
    csv = File.read(params[:file].path)
    CSV.parse(csv, headers: true).each do |row|
      # options = { variants_attrs: variants_params, options_attrs: option_types_params }
      product = Spree::Product.create(
          name: row[1],
          description: row[10],
          price: row[8],
          shipping_category_id: 1,
          available_on: Time.now
      )
      # loop to all picture url and create product image
      (16..25).each do |i|
        next if row[i].nil?
        if (!row[i].empty?)
          encoded_url = URI.encode(row[i])
          file = open(encoded_url)
          image = product.images.create(attachment: {io: file, filename: File.basename(file.path)})
        end
      end

      # create product variant if product have variants
      next if row[15].nil? || row[15].empty?
      options_value = row[15].split("/")
      options_value.each do |option_value|
        if (option_value.include? "Size") && (option_value.include? "Color")
          # both size and color
          i = option_value.index("Size")
          j = option_value.index("Color")
          size = option_value[i..j-1].gsub('Size','').strip
          color = option_value.from(j).gsub('Color', '').strip

          sizeOptionValue = find_or_create_option_value 1, size
          colorOptionValue = find_or_create_option_value 2, color
          option_value_ids = []
          option_value_ids << sizeOptionValue.id
          option_value_ids << colorOptionValue.id

          product.variants.create(price: product.price, option_value_ids: option_value_ids)

        elsif (option_value.include? "Size") && !(option_value.include? "Color")
          # only size
          size = option_value.gsub('Size', '').strip
          sizeOptionValue = find_or_create_option_value 1, size
          option_value_ids = []
          option_value_ids << sizeOptionValue.id
        else
          # only color
          color = option_value.gsub('Color', '').strip
          colorOptionValue = find_or_create_option_value 2, color
          option_value_ids = []
          option_value_ids << colorOptionValue.id
        end
      end
    end

    flash[:notice] = "Products imported!"
    redirect_to admin_import_path
  end

  private

  def find_or_create_option_value option_type_id, name
    scope ||= Spree::OptionType.find(option_type_id).option_values

    @option_value =scope.find_or_create_by(name: name) do |option_value|
      option_value.presentation = name
    end
  end
end

#   https://stackoverflow.com/questions/30395750/ruby-on-rails-4-csv-import-no-implicit-conversion-into-string
#   import with association, should move this to model, not handle in controller
#   refer to this link for the answer: https://gorails.com/forum/rails-csv-import-with-associations
#   https://mattboldt.com/importing-massive-data-into-rails/
#   change later
#
#
# should add handle error when option is not in right format
# begin
#   @user = User.find_by!(id: 1)
# rescue StandardError => e
#   print e
# end
