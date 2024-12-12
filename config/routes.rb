Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  
  get "up" => "rails/health#show", as: :rails_health_check

  resources :recipes do
    resources :favorites, only: [:create, :destroy, :index]
    collection do
      get 'detect_ingredients'
      post 'analyze_image'
    end
  end
  resources :favorites, only: [:index]
end