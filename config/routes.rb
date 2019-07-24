Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }


  namespace :admin do
    resources :calculations
  end

  unauthenticated do
    root to: 'home#index'
  end

  authenticated do
    root :to => 'admin#index'
  end


end
