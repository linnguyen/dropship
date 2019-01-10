Spree::Core::Engine.add_routes do
  # Add your extension routes here
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      post "/image_url" => "images#upload_image_using_static_url"

      resources :products do
        post "/image_upload" => "images#create_image_via_url"
      end
    end
  end

  get '/shipping_return', to: 'products#shipping_return'
end





