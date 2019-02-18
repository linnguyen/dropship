Spree::Core::Engine.add_routes do
  # Add your extension routes here
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      post "/image_url" => "images#upload_image_using_static_url"

      resources :products do
        post "/image_upload" => "images#create_image_via_url"
      end

      resources :variants do
        post "/image_upload" => "images#create_image_via_url"
      end

      resources :option_types do
        post "/find_or_create_option_value" => "option_values#find_or_create"
      end
    end
  end

  namespace :admin do
    post '/bulk', :to => 'products#bulk_upload'
    get '/import', :to => 'products#import'
  end

  get '/shipping_return', to: 'policy#shipping_return'
  get '/about', to: 'policy#about'
end





