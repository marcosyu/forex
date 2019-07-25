Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  get 'signout' => 'devise/sessions#destroy', :as => :destroy_user_session

  namespace :admin do
    resources :calculations
    resources :exchange_rates
  end

  root :to => 'home#index'



end
