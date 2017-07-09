Rails.application.routes.draw do
  use_doorkeeper
  namespace :api, format: 'json' do
    namespace :v1 do
      get  '/me'       => 'credentials#me'
      get  '/stickies' => 'stickies#index'
      post '/stickies' => 'stickies#import'
      get  '/pages'    => 'pages#index'
    end
  end

  root :to => 'stickies#index'
  resources :user_sessions
  resources :users do
    resources :stickies, only: :index
  end
  resources :password_resets
  resources :stickies
  resources :pages, except: [:new, :destroy] do
    resources :stickies
  end
  resources :tags, only: :index do
    resources :stickies, only: :index
  end

  get 'oauths/oauth'
  get 'oauths/callback'

  post 'oauth/callback'  => 'oauths#callback'
  get  'oauth/callback'  => 'oauths#callback' # for use with Github, Facebook
  get  'oauth/:provider' => 'oauths#oauth', :as => :auth_at_provider

  get  'login'  => 'user_sessions#new',     :as => :login
  post 'logout' => 'user_sessions#destroy', :as => :logout

end
