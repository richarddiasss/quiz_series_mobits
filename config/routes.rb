Rails.application.routes.draw do
  resources :characters
  resources :series
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  namespace :api do
    # Supondo que você já tenha a rota para create
    post '/login', to: 'auth#login'
    get '/me', to: 'auth#info_user'
    # Outras rotas protegidas aqui
  end

  get '/question', to: "series#question"
  put '/answer', to: "series#answer_question"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
