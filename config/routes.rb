PracticingRubyWeb::Application.routes.draw do
  root :to => 'home#index'

  match "/hooks/#{MailChimp::SETTINGS[:webhook_key]}" => 'hooks#receive'
  match '/articles/shared/:secret' => 'articles#shared', :as => "shared_article"

  resources :articles do
    member do
      get 'share'
    end
  end

  resources :authorization_links
  resources :sessions

  resources :comments

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
