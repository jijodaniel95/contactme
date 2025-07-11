Rails.application.routes.draw do
  # API routes
  namespace :api do
    post "contacts", to: "contact#create"
    get "health", to: "health#index"
  end

  # Legacy route for compatibility
  post "contact/create", to: "api/contact#create"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Root path for API documentation
  root "rails/welcome#index"
end
