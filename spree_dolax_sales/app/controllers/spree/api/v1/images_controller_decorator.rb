module Spree
  module Api
    module V1
       ImagesController.class_eval do

         def create_image_via_url
           authorize! :create, Image
           file = open(params[:url])
           @image = scope.images.create(attachment: {io: file, filename: File.basename(file.path) })
           if @image
             respond_with(@image, status: 201, default_template: :show)
           else
             invalid_resource!(@image)
           end
         end

       end
    end
  end
end