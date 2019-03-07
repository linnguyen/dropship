Spree::Admin::ProductsController.class_eval do
  require 'csv'

  # for scrape data

  require 'openssl'
  require 'nokogiri'
  require 'open-uri'

  # Don't allow downloaded files to be created as StringIO. Force a tempfile to be created.
  OpenURI::Buffer.send :remove_const, 'StringMax' if OpenURI::Buffer.const_defined?('StringMax')
  OpenURI::Buffer.const_set 'StringMax', 0

  def import
    @relation_type  = Spree::RelationType.all

    # load all taxons
    @taxons = if taxonomy
                taxonomy.root.children
              elsif params[:ids]
                Spree::Taxon.includes(:children).accessible_by(current_ability, :read).where(id: params[:ids].split(','))
              else
                Spree::Taxon.includes(:children).accessible_by(current_ability, :read).order(:taxonomy_id, :lft)
              end
    @taxons = @taxons.ransack(params[:q]).result
    @taxons = @taxons.page(params[:page]).per(params[:per_page])
  end

  def taxonomy
    if params[:taxonomy_id].present?
      @taxonomy ||= Spree::Taxonomy.accessible_by(current_ability, :read).find(params[:taxonomy_id])
    end
  end

  def bulk_upload
    csv = File.read(params[:file].path)
    CSV.parse(csv.gsub('\"', '""'), headers: true).each do |row|
      # increase price by 80 or 75 percent randomly
      increase_by = 0.90
      if [true, false].sample
        increase_by = 0.8
      else
        increase_by = 0.75
      end
      price_new = row[8].to_f + row[8].to_f * increase_by
      product = Spree::Product.create(
          name: row[1],
          description: row[10],
          price: price_new,
          shipping_category_id: 1,
          available_on: Time.now,
      )
      # update taxons
      taxon_ids = []
      taxon_ids << params[:taxon_ids]
      product.taxon_ids = taxon_ids

      # # update related product
      # relation_ids = []
      # relation_ids << params[:relation_type_id]
      # product.relation_ids = relation_ids

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

      # get doc scrape data from banggood
      url = row[13]
      doc = Nokogiri::HTML(open(url))
      number_of_tr = doc.css('div.pro_attr_box table tr')
      # only size or color
      if (number_of_tr.size == 2)
        data_doc = doc.css('div.pro_attr_box table tr[1] td li')
      end
      # both size and color
      if (number_of_tr.size == 3)
        data_doc = doc.css('div.pro_attr_box table tr[2] td li')
      end
      images_hash = Hash.new
      imageid_hash = Hash.new
      data_doc.each do |image_li|
        image = image_li.css('img')
        next if image.empty?
        name_color = image.attr('title').value.strip
        url = image_li.css('img').attr('viewimage').value
        images_hash[name_color] = url
      end


      options_value = row[15].split("/")
      options_value.each do |option_value|
        if (option_value.include? "Size") && (option_value.include? "Color")
          # both size and color
          i = option_value.index("Size")
          j = option_value.index("Color")
          size = option_value[i..j - 1].gsub('Size', '').strip
          color = option_value.from(j).gsub('Color', '').strip

          sizeOptionValue = find_or_create_option_value 1, size
          colorOptionValue = find_or_create_option_value 2, color
          option_value_ids = []
          option_value_ids << sizeOptionValue.id
          option_value_ids << colorOptionValue.id

          # create variant
          variant = product.variants.create(price: product.price, option_value_ids: option_value_ids)

          # create variant image here by scrape data from banggood
          if (!images_hash.empty?)
            variant_url = images_hash[colorOptionValue.presentation]
            encoded_url = URI.encode(variant_url)
            file = open(encoded_url)
            if imageid_hash.key?(colorOptionValue.presentation)
              variant.images << Spree::Asset.find(imageid_hash[colorOptionValue.presentation])
            else
              image = variant.images.create(attachment: {io: file, filename: File.basename(file.path)})
              imageid_hash[colorOptionValue.presentation] = image.id
            end
          end

        elsif (option_value.include? "Size") && !(option_value.include? "Color")
          # only size
          size = option_value.gsub('Size', '').strip
          sizeOptionValue = find_or_create_option_value 1, size
          option_value_ids = []
          option_value_ids << sizeOptionValue.id

          # create variant
          variant = product.variants.create(price: product.price, option_value_ids: option_value_ids)

          # create variant image here by scrape data from banggood
          if (!images_hash.empty?)
            variant_url = images_hash[colorOptionValue.presentation]
            encoded_url = URI.encode(variant_url)
            file = open(encoded_url)
            if imageid_hash.key?(colorOptionValue.presentation)
              variant.images << Spree::Asset.find(imageid_hash[colorOptionValue.presentation])
            else
              image = variant.images.create(attachment: {io: file, filename: File.basename(file.path)})
              imageid_hash[colorOptionValue.presentation] = image.id
            end
          end

        elsif !(option_value.include? "Size") && (option_value.include? "Color")
          # only color
          color = option_value.gsub('Color', '').strip
          colorOptionValue = find_or_create_option_value 2, color
          option_value_ids = []
          option_value_ids << colorOptionValue.id

          # create variant
          variant = product.variants.create(price: product.price, option_value_ids: option_value_ids)

          # create variant image here by scrape data from banggood
          if (!images_hash.empty?)
            variant_url = images_hash[colorOptionValue.presentation]
            encoded_url = URI.encode(variant_url)
            file = open(encoded_url)
            if imageid_hash.key?(colorOptionValue.presentation)
              variant.images << Spree::Asset.find(imageid_hash[colorOptionValue.presentation])
            else
              next if !file.path.present?
              image = variant.images.create(attachment: {io: file, filename: File.basename(file.path)})
              imageid_hash[colorOptionValue.presentation] = image.id
            end
          end

        end
      end

    end

    flash[:notice] = "Products imported!"
    redirect_to admin_import_path
  end

  private

  def find_or_create_option_value option_type_id, name
    scope ||= Spree::OptionType.find(option_type_id).option_values

    @option_value = scope.find_or_create_by(name: name) do |option_value|
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
