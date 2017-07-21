Rails.application.routes.draw do
  resources :entries
  resources :entities
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "users/registrations" }

  resources :chats
  resources :companies
  resources :categories

  get  'invites/index' => 'invites#index', as: 'invites'
  post 'invites/invite' => 'invites#invite', as: 'invite'

  get 'users/new-company' => 'users/registrations#new_company'
  post 'pages/chat' => 'pages#chat', as: 'test_chat'
  root 'pages#index'

  post '/chats/webhook' => 'chats#webhook'
end
