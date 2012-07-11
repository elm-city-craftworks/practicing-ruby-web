PracticingRubyWeb::Application.routes.draw do
  root :to => 'home#index'

  match "/hooks/#{MailChimp::SETTINGS[:webhook_key]}" => 'hooks#receive'
  match '/articles/shared/:secret' => 'articles#shared',    :as => "shared_article"
  match '/subscribe'               => 'sessions#subscribe', :as => 'subscribe'

  match "/library" => 'home#library'
  match "/volume/:volume/" => 'articles#index'
  match "/volume/:volume/issue/:issue" => 'articles#show'
  match "/collection/:collection/" => 'articles#index'

  resources :articles do
    member do
      get 'share'
    end
  end

  resources :authorization_links
  resources :sessions do
    collection do
      get 'problems'
    end
  end

  resources :comments do
    collection do
      post 'parse'
    end
  end

  match '/sessions/link/:secret' => 'sessions#link'
  match '/auth/github/callback' => 'sessions#create'
  match '/logout' => 'sessions#destroy', :as => 'logout'

  resource :community, :controller => "community" do
    member do
      get 'faq'
    end
  end

  resources :announcements

  match '/users/settings' => 'users#edit', :as => "user_settings"
  resources :users

  namespace :admin do
    resources :announcements
    resources :articles
  end

end
