Spree::Core::Engine.add_routes do
  # Add your extension routes here
   namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
        post "/image_url" => "images#upload_image_using_static_url"
    end
  end
end





