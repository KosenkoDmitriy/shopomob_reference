Shopomob::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config

  namespace :admin do
    resources :shops do
      get :autocomplete_category_item_name, :on => :collection
      get :autocomplete_shop_name, :on => :collection
    end
  end
  ActiveAdmin.routes(self)

  # start for testing rails4-autocomplete gem
  resources :brands
  resources :products do
    get :autocomplete_brand_name, :on => :collection
  end
  ##get 'autocomplete_category_item_name' => 'home#index'
  # ending for testing rails4-autocomplete gem


  # sart apis
  namespace :api, :defaults => {:format => :json}  do
    namespace :v1 do
      resources :category
      resources :t_category
      resources :shops
      resources :images
      get 'online' => 'shops#online'
    end
  end
  # finish apis

  root 'home#index'
  #resources :category
  #resources :t_category
  #resources :shops
  get 'services' => 'home#services'
  get 'contacts' => 'home#contacts'

  get 'shops' => 'home#shops'
  get 'shops/:id' => 'home#shops'
  get 'shops/:id/:search' => 'home#shops'

  post 'shops' => 'home#shops'
  post 'shops/:id' => 'home#shops'
  post 'shops/:id/:search' => 'home#shops'

  #get 'search/shop' => 'home#shops', as: "search_shop"
  #post 'search/shop' => 'home#shops'

  get 'tcats' => 'home#tcats', as: "tcats"
  get 'tcats/:id' => 'home#tcats'
  get 'cats' => 'home#cats'
  get 'cats/:id' => 'home#cats'

  get 'serve/:filename/:extension' => 'home#serve'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
