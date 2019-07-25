Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' } do
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  namespace :admin do
    resources :exchange_rates
  end

  mount Resque::Server.new, :at => "/resque"

  root :to => 'home#index'



end
