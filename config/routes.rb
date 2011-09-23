PracticingRubyWeb::Application.routes.draw do

  root :to => 'home#index'

  match '/hooks/2f94d5ec414b463caa8d6f5f98bff105fd1b2151112' => 'hooks#receive'

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

  match 'markdown/parse' => 'markdown#parse', :as => "parse_markdown"

end
