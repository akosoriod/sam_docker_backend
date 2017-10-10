Rails.application.routes.draw do
  resources :users
  resources :places
  post 'users/login', to: 'users#login'
  get 'user/:username', to: 'users#show_username'
  # For details on the DSL available within this file, see http://guides.rubyonrails.orgroutil
end
