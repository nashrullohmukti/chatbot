Rails.application.routes.draw do
  resources :intents
  resources :entries
  resources :entities
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "users/registrations" }

  resources :chats
  resources :companies
  resources :categories

  get  'invites/index' => 'invites#index', as: 'invites'
  post 'invites/invite' => 'invites#invite', as: 'invite'

  root 'pages#index'

  post '/chats/webhook' => 'chats#webhook'
end
