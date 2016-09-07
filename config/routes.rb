Rails.application.routes.draw do
  resources :clients
  resources :invoices
  resources :projects, except: [:show]

  get 'portfolio/:id', to: "projects#show", as: :portfolio_project

  get 'portfolio', to: "pages#portfolio"
  get 'contact', to: "pages#contact"
  get 'cv', to: "pages#cv"

  get 'login', to: "sessions#new"
  post 'login', to: "sessions#create"
  delete 'logout', to: "sessions#destroy", as: :logout

  root "pages#index"
end
