Spree::Admin::ImagesController.class_eval do
  create.before :set_variants
  update.before :set_variants

  private

    def set_variants
      @image.variant_ids = viewable_ids
    end

    def viewable_ids # don't know why this version use array of viewable_ids while params only single viewable_id
      params[:image][:viewable_id]
    end
end