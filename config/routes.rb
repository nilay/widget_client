Rails.application.routes.draw do
  resources :sessions
  root to: "home#index"
  get "users/me" => "users#me"
  resources :users do 
  	member do
  		get 'widgets'
  	end
  end

  resources :widgets

  resource :session, only: [:new, :create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
