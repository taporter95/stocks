Rails.application.routes.draw do
  devise_for :users
  get 'welcome/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :stocks, only: [:index, :show] do 
    collection do 
      get 'info'
    end
  end

  root 'stocks#index'
end
