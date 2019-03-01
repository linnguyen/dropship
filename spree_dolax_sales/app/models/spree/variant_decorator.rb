Spree::Variant.class_eval do
  has_many :variant_images, class_name: '::Spree::VariantImage'
  has_many :images_for_variant, through: :variant_images, source: :image
  has_many :images, -> { order(:position) }, as: :viewable

  def images
    images_for_variant
  end

  def image_ids
    image_ids = []
    self.images.each do |i|
       image_ids.push i.id
    end
    return image_ids
  end
end
