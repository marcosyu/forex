Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  delete 'signout' => 'devise/sessions#destroy', :as => :destroy_user_session

  namespace :admin do
    resources :calculations
    resources :exchange_rates
  end

  mount Resque::Server.new, :at => "/resque"

  root :to => 'home#index'



end
