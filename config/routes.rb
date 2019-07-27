Rails.application.routes.draw do
  require 'resque/scheduler'
  require 'resque/scheduler/server'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  namespace :admin do
    resources :favorite_exchange_rates
  end

  mount Resque::Server.new, :at => "/resque"

  root :to => 'home#index'



end
