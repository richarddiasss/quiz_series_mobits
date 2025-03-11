Rails.application.routes.draw do
  resources :characters
  resources :series
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  namespace :api do
    namespace :v1 do
      post '/login.json', to: 'auth#login'
      get '/placar.json', to: 'auth#info_user'
      get '/questao.json', to: 'series#question'
      put '/resposta.json', to: 'series#answer_question'
    end
  end
  

  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
