PracticingRubyWeb::Application.routes.draw do
  root :to => 'home#public_archives'

  mount StripeEvent::Engine => STRIPE_WEBHOOK_PATH

  match "/hooks/#{MailChimpSettings[:webhook_key]}" => 'hooks#receive'
  match '/articles/shared/:secret' => 'articles#shared', :as => "shared_article"
  match '/subscribe'               => 'home#subscribe',  :as => 'subscribe'

  get "/library",  :to => redirect('/articles')
  get "/explore",  :to => redirect('/articles')
  get "/archives", :to => redirect('/articles#archives')
  get "/archives/public" => 'home#public_archives'
  get "/contact"         => 'home#contact', :as => 'contact'
  get "/articles/random" => 'articles#random', :as => 'random_article'

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
