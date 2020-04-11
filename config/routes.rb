Rails.application.routes.draw do
  get 'searches/search'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


    get '/api/v1/new_search', to: 'test#start'

    get '/api/v1/beta', to: 'test#beta'

    get '/test', to: 'test#start'


end
