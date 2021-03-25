Rails.application.routes.draw do
  # Add your routes here
  root 'welcome#home'
  
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'

  match '/auth/:provider/callback', to: 'sessions#create', via: [:get, :post] 
  # match '/auth/github/callback', to: 'sessions#create', via: [:get, :post]
  get '/auth/github/callback', to: 'sessions#create'

  # get '/auth/google_oauth2/callback', to: 'sessions#omniauth', as: "google_oauth2"
  get '/auth/google_oauth2/callback', to: 'sessions#create'

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  post '/logout', to: 'sessions#destroy'
end
