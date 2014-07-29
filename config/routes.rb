Shopomob::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)
  #scope ":locale", :path_prefix => '/:locale' do
  #  ActiveAdmin.routes(self)
  #end

  namespace :api, :defaults => {:format => :json}  do
    namespace :v1 do
      resources :category
      resources :t_category
      resources :shops
      resources :images
      get 'online' => 'shops#online'
    end
  end

  #resources :shops
  root 'home#index'
  #resources :category
  #resources :t_category
  #resources :shops
  get 'services' => 'home#services'
  get 'contacts' => 'home#contacts'
  get 'services/adv' => 'home#services_adv'

  get 'shops' => 'home#shops'

  get 'search/shop/:q' => 'home#shops', as: "search_shop"
  post 'search/shop/:q' => 'home#shops'

  get 'shops/:id' => 'home#shops'
  get 'tcats' => 'home#tcats'
  get 'tcats/:id' => 'home#tcats'
  get 'cats' => 'home#cats'
  get 'cats/:id' => 'home#cats'

  get 'services/rent_shop' => 'home#services_rent_shop'
  get 'services/rent_app' => 'home#services_rent_app'
  get 'services/sms' => 'home#services_sms'

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
