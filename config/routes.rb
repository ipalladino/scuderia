SampleApp::Application.routes.draw do
  resources :saved_searches


  match '/bookmarks/toggle', to: 'bookmarks#toggle'
  #facebook
  match 'auth/:provider/callback', to: 'users#facebook_callback'
  match 'auth/failure', to: redirect('/')
  
  resources :blogs

  match 'car_models/crawlModel', to: 'car_models#crawlModel'
  match 'car_models/list', to: 'car_models#list_models'
  resources :car_models do
    member do
      get :filter_by_year
    end
  end
  match '/filter_car_models', to: 'car_models#filter_by_from_to'
  match '/model_search', to: 'car_models#search'
  match '/get_model', to: 'car_models#get_model'

  match '/ferraris/remove_image', to: 'ferraris#remove_image'
  match '/ferraris/add_image', to: 'ferraris#add_image'
  resources :ferraris do
    member do
      get :year_selection, :model_selection, :preview, :confirm, :publish
    end
  end
  match '/basic_search', to: 'ferraris#search'
  
  resources :users do
    member do
      get :following, :followers
    end
  end
  
  resources :transmissions do
    member do
      get :year_selection
    end
  end
  
  resources :engines do
    member do
      get :year_selection
    end
  end  

  resources :years
  resources :sessions, only: [:new, :create, :destroy]

  match '/crawl', to: 'ferraris#crawl'
  match '/myferraris', to: 'ferraris#my'

  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete
  
  root to: 'static_pages#home'

  match '/inbox/send_message',   to: 'static_pages#send_message'
  match '/inbox/compose',   to: 'static_pages#compose'
  match '/inbox/conversation',   to: 'static_pages#conversation'
  match '/inbox',   to: 'static_pages#inbox'
  match '/help',    to: 'static_pages#help'
  match '/about',   to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'
  match '/termsofservice', to: 'static_pages#termsofservice'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
