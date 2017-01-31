Rails.application.routes.draw do

  get 'messages/index'
  get 'welcome/index'
  get 'welcome/search'
  get 'welcome/upgrade'
  resources :groups

  post 'groups/add_user_to_group'

  resources :documents do
    collection do
      match 'search' => 'welcome#search', via: [:get, :post], as: :search
      get 'add_doc_to_group'
    end
    member do
      get 'send_doc'
      get 'download_doc'
      get 'show_doc'
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

    authenticated :user, lambda {|u| u.has_role? :viewUser} do
      resources :document_groups, only: [:index]
      get 'document_groups/project', as: 'doc_project'
      root 'document_groups#index', as: :authenticated_viewUser
      mount PdfjsViewer::Rails::Engine => "/pdf_documents", as: 'pdfjs'
    end

    authenticated :user, lambda {|u| u.has_role? :admin} do
      root 'welcome#index', as: :authenticated_admin
      mount PdfjsViewer::Rails::Engine => "/pdf_documents", as: 'pdfjs_admin'
    end

    authenticated :user, lambda {|u| u.has_role? :uploadUser} do
      root 'welcome#index', as: :authenticated_uploadUser
      mount PdfjsViewer::Rails::Engine => "/pdf_documents", as: 'pdfjs_uploaduser'
    end
  end
  #

  namespace :admin do
    get 'logs/index'
    get 'logs/viewUser'
    get 'logs/uploadUser'
    get 'logs/adminUser'
    resources :documents do
      member do
        get 'remove_document'
        get 'restore_document'
      end
      collection do
        get :recycle_bin
      end
    end

    resources :users do
      member do
        get :disable_user
        get :enable_user
        post :reset_password
        match :password_update, to: 'users#password_update', as: :password_update, via: :post
      end
      collection do
        resources :roles do
          member do
            get :del_role
          end
        end
        post :add_user_role, as: :add_user_role
        get :add_sms_group, as: :add_sms_group
      end
    end
    resources :groups do
      member do
        get :remove_user
        get :disable_group
        get :enable_group
      end
    end
    resources :user_groups
    # get 'users/remove_user_role' => 'users#remove_user_role', as: :delete_user_role
    resources :users_roles, only: [:index, :create, :destroy, :new] do
      # post :change_role
    end

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
