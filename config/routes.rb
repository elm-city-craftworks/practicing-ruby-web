PracticingRubyWeb::Application.routes.draw do
  root :to => 'home#index'

  match "/hooks/#{MailChimp::SETTINGS[:webhook_key]}" => 'hooks#receive'
  match '/articles/shared/:secret' => 'articles#shared', :as => "shared_article"
  match '/subscribe'               => 'home#subscribe',  :as => 'subscribe'

  match "/library" => 'home#library'
  match "/volume/:volume/" => 'articles#index'
  match "/volume/:volume/issue/:issue" => 'articles#show'
  match "/collection/:collection/" => 'articles#index'
  match "/faq" => 'home#faq', :as => 'faq'
  match "/contact" => 'home#contact', :as => 'contact'
  match "/articles/samples" => 'articles#samples', :as => 'sample_articles'

  match "articles/random" => 'articles#random', :as => 'random_article'

  match "collections/:collection" => 'articles#index', :as => 'collection'
  match "volumes/:volume"         => 'articles#index', :as => 'volume'

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

  scope "/registration", :as => 'registration' do
    get   '/'                     => 'registration#index'
    get   'edit_profile'          => 'registration#edit_profile'
    match 'update_profile'        => 'registration#update_profile'
    get   'confirm_email/:secret' => 'registration#confirm_email',
      :as => 'confirmation'
    get   'payment'               => 'registration#payment'
    get   'restart'               => 'registration#restart'
  end

  match '/sessions/link/:secret' => 'sessions#link'
  match '/auth/github/callback' => 'sessions#create'
  match '/logout' => 'sessions#destroy', :as => 'logout'
  match '/auth/github', :as => 'login'

  match '/dismiss_broadcasts' => 'announcements#dismiss', :as => 'dismiss_broadcasts'

  match '/users/settings' => 'users#edit', :as => "user_settings"
  resources :users

  namespace :admin do
    resources :announcements
    resources :articles
    resources :broadcasts
  end

end
