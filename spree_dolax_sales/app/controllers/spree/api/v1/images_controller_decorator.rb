module Spree
  module Api
    module V1
       ImagesController.class_eval do
      
       def upload_image_using_static_url
          product = Spree::Product.find_by(id: params[:id])
          params[:static_urls].each do |static_url|
              product.images.create!(static_url: static_url, attachment_file_name:"static-url")
          end
       end

        def create_v1
          authorize! :create, Image
          @image = scope.images.new(image_params)
          if @image.save
            respond_with(@image, status: 201, default_template: :show)
          else
            invalid_resource!(@image)
          end
        end
        
        private

        def image_params
          params.permit(:images)
        end

        def scope
          if params[:product_id]
            Spree::Product.friendly.find(params[:product_id])
          elsif params[:variant_id]
            Spree::Variant.find(params[:variant_id])
          end
        end
       
     end
    end
  end
end