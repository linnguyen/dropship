module Spree
  Product.class_eval do
    has_many :nonuniq_variant_images, -> {order(:position)}, source: :images, through: :variants_including_master

    def images_of_variants
      images = []
      self.variants.each do |variant|
        variant.images.each do |image|
          next if images.include? image
          images << image
        end
      end
      return images
    end

    def variant_images
      variant_images = Spree::VariantImage.where(variant_id: variant_ids)
      Spree::Image.where(id: variant_images.pluck(:image_id), viewable_type: 'Spree::Variant').order(position: :asc)
    end

    # Find the Product's Variant from an array of OptionValue ids
    def find_variant_by_options(array_option_value_ids)
      # option_values = Spree::OptionValue.where(id: array)
      # variants = []
      # option_values.each do |option_value|
      #   variants.push(option_value.variants.ids)
      # end
      # self.variants.find_by(:id => variants.inject(:&).first)
      #
      #
      self.variants.select {|variant| variant.option_value_ids == array_option_value_ids.map(&:to_i)}.first

    end


    def option_values
      @_option_values ||= Spree::OptionValue.for_product(self).order(:position).sort_by {|ov| ov.option_type.position}
    end

    def grouped_option_values
      @_grouped_option_values ||= option_values.group_by(&:option_type)
    end

    def variants_for_option_value(value)
      @_variant_option_values ||= variants.includes(:option_values).all
      @_variant_option_values.select {|i| i.option_value_ids.include?(value.id)}
    end

    def variant_options_hash
      return @_variant_options_hash if @_variant_options_hash
      hash = {}
      variants.includes(:option_values).each do |variant|
        variant.option_values.each do |ov|
          otid = ov.option_type_id.to_s
          ovid = ov.id.to_s
          hash[otid] ||= {}
          hash[otid][ovid] ||= {}
          hash[otid][ovid][variant.id.to_s] = variant.to_hash
        end
      end
      @_variant_options_hash = hash
    end

  end
end