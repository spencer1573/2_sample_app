Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  get     'sessions/new'

  root    'static_pages#home'
# notice how important to distinguish
# static_pages/help
# vs
# static_pages#help
# i don't know why they are different. i will find out sometime. 
  get     'help'    => 'static_pages#help'
  get     'about'   => 'static_pages#about'
  get     'contact' => 'static_pages#contact'
  
  get     'signup'  => 'users#new'

# figured out how important it is that you don't always put get for routes
# sometimes you put post and delete. for security we better make sure
# we descriptify posts... i'm guessing.
  get     'login'   => 'sessions#new'
  post    'login'   => 'sessions#create'
  delete  'logout'  => 'sessions#destroy'
  
  # i think because of this everything in the app/views/users folder
  # is put in automatically and paired up so you don't have to 
  # manually do it.
  resources :users
  # this is what only does:  
  # https://github.com/plataformatec/devise/wiki/How-To:-Define-resource-actions-that-require-authentication-using-routes.rb
  # this is what resources does: 
  # http://stackoverflow.com/questions/4420754/get-match-and-resources-in-routes-rb
  # so this is another way of saying what the line below says: (i believe)
  # notice how :id is the variable in this route.
  # get    "account_activations/:id/edit" => "account_activations#edit",    :as => 'edit_account_activations'
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  #root 'application#hello'

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
