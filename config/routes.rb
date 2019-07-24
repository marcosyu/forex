Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }


  resource :user do
    resources :calculations
  end

  root to: 'home#index'
end
