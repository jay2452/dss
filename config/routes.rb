Rails.application.routes.draw do


  get 'welcome/index'

  get 'welcome/search'

  # get 'roles/index'
  #
  # get 'users/index'

  resources :documents do
    collection do
      match 'search' => 'welcome#search', via: [:get, :post], as: :search
    end
  end

  devise_for :users


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  #  root 'devise/sessions#new'
  devise_scope :user do
    get '/login' => 'devise/sessions#new', as: :login
    delete '/logout' => 'devise/sessions#destroy', as: :logout
    unauthenticated do
      root 'devise/sessions#new'
    end

    authenticated do
      root 'welcome#index', as: :authenticated_user
    end
  end
  #
  # authenticated :user, lambda {|u| u.has_role? :admin} do
  #   root 'admin/documents#index', as: :authenticated_admin
  # end
  #
  # authenticated :user, lambda {|u| u.has_role? :general} do
  #   root 'documents#index', as: :authenticated_general_user
  # end


  namespace :admin do
    resources :documents
    resources :users do
      collection do
        resources :roles
        post :add_user_role, as: :add_user_role
        get :add_sms_group, as: :add_sms_group
      end
    end
    # post 'users/add_user_role' => 'users#add_user_role', as: :add_user_role
    resources :groups
    resources :user_groups
    # get 'users/remove_user_role' => 'users#remove_user_role', as: :delete_user_role
    resources :users_roles, only: [:index, :create, :destroy, :new]
    resources :document_categories, only: [:index, :create, :destroy]
  end

  # get 'admin/users/add_sms_group', to: 'admin/users#add_sms_group', as: :add_sms_group

  # scope :admin do
  #   resources :documents
  # end

  get '*path' => redirect('/')

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
