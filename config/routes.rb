Rails.application.routes.draw do
  namespace :api, path: '/', defaults: { format: :json } do
    namespace :v1 do
      get 'mind-maps', to: 'maps#index'
      post 'mind-maps/:id/invite', to: 'maps#invite'
      patch 'mind-maps/:id/publish', to: 'maps#publish'
      
      get 'my-maps', to: 'maps#my_maps'
      
      get 'users/:username/mind-maps', to: 'maps#index'

      put 'edit-profile', to: 'users#edit_profile'

      # resources :users, param: :username, only: %i[index] do
      #   resources :maps, only: %i[index]
      # end
    end
  end
end
