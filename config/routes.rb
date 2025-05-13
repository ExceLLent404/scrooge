Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up", to: "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker", to: "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest", to: "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "transactions#index"

  devise_for :users, controllers: {registrations: "users/registrations"}

  get "capital", to: "capital#show"

  resources :accounts do
    get "offer", on: :new
  end

  resources :categories do
    get "offer", on: :new
  end

  resources :transactions
end
