Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  resources :games do
    collection do
      get 'new_vs_ai', to: 'games#new_vs_ai'
      post 'create_vs_ai', to: 'games#create_vs_ai'
    end
  end

  resources :decks
  # Additional static pages
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'

  # Defines the root path route ("/")
  # root "posts#index"
end
