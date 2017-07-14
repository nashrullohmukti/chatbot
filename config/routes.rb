Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "users/registrations" }

  resources :chats
  resources :companies
  resources :categories

  get  'invites/index' => 'invites#index', as: 'invites'
  post 'invites/invite' => 'invites#invite', as: 'invite'

  get 'users/new-company' => 'users/registrations#new_company'

  root 'pages#index'
end
