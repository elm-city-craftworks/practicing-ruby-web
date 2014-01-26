PracticingRubyWeb::Application.routes.draw do
  root :to => 'home#library'

  mount StripeEvent::Engine => STRIPE_WEBHOOK_PATH

  match "/hooks/#{MailChimpSettings[:webhook_key]}" => 'hooks#receive'
  match '/articles/shared/:secret' => 'articles#shared', :as => "shared_article"
  match '/subscribe'               => 'home#subscribe',  :as => 'subscribe'

  match "/library"  => 'home#library'
  match "/explore"  => 'home#explore'
  match "/archives" => 'home#archives'
  match "/archives/public" => 'home#public_archives'
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

  resources :subscriptions, :except => [:destroy, :edit, :update, :show] do
    collection do
      get :redirect
      get :coupon_valid
    end
  end

  match '/sessions/link/:secret'   => 'sessions#link'
  match '/auth/:provider/callback' => 'sessions#create'
  match '/auth/failure'            => 'sessions#failure'
  match '/logout'                  => 'sessions#destroy', :as => 'logout'
  match '/login'                   => 'sessions#new',     :as => 'login'

  match '/dismiss_broadcasts' => 'announcements#dismiss', :as => 'dismiss_broadcasts'

  # Legacy route for old notification emails
  match '/users/settings' => 'users#profile', :as => "user_settings"

  scope '/settings' do
    get 'profile'       => 'users#profile',       :as => 'profile_settings'
    get 'notifications' => 'users#notifications', :as => 'notification_settings'
    get 'billing'       => 'users#billing',       :as => 'billing_settings'

    # Billing
    post 'update_credit_card' => 'users#update_credit_card',
      :as => 'update_credit_card'
    get 'current_credit_card' => 'users#current_credit_card',
      :as => 'current_credit_card'
  end

  resources :users do
    member do
      post :change_billing_interval
      post :mailchimp_yearly_billing
    end
    collection do
      get :email_unique
    end
  end

  controller :user_email do
    get  '/account/email/confirm/:secret', :action => 'confirm',
      :as => 'confirm_email'
    post '/account/email/dismiss_warning', :action => 'dismiss_warning',
      :as => 'dismiss_email_warning'
    get '/account/email/change', :action => 'change',
      :as => 'change_email'
  end

  namespace :admin do
    resources :announcements
    resources :articles
    resources :broadcasts
    resources :reports, :only => [:index]

    match "/magic/freebie/:nickname" => "magic#freebie"
    match "/magic/hashed_id/:nickname" => "magic#hashed_id"
  end

end
