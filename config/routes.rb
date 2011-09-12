PracticingRubyWeb::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

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
      get 'welcome'
    end
  end

  resources :announcements

  namespace :admin do
    resources :announcements
  end

end
