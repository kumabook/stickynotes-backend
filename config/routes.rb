Rails.application.routes.draw do
  use_doorkeeper
  namespace :api, format: 'json' do
    namespace :v1 do
      get  '/me'       => 'credentials#me'
      get  '/stickies' => 'stickies#index'
      post '/stickies' => 'stickies#import'
    end
  end

  root :to => 'user_sessions#new'
  resources :user_sessions
  resources :users
  resources :password_resets
  resources :stickies, except: :create
  resources :pages do
    resources :stickies
  end
  resources :tags

  get 'oauths/oauth'
  get 'oauths/callback'

  post 'oauth/callback'  => 'oauths#callback'
  get  'oauth/callback'  => 'oauths#callback' # for use with Github, Facebook
  get  'oauth/:provider' => 'oauths#oauth', :as => :auth_at_provider

  get  'login'  => 'user_sessions#new',     :as => :login
  post 'logout' => 'user_sessions#destroy', :as => :logout

end
