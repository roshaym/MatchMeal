Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  resources :recipes do
    resources :favorites, only: [:create, :destroy, :index]
    # Add a custom route for ingredient detection
    get 'detect_ingredients', on: :collection
    
    # Add a custom POST route with a named route
    post 'process_image', to: 'recipes#process_image', on: :collection, as: :process_image
  end

  resources :favorites, only: [:index]
end