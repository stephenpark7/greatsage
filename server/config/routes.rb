# frozen_string_literal: true

Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    namespace :v1 do
      namespace :auth do
        post 'register', as: :register
        post 'login', as: :login
        post 'logout', as: :logout
        post 'refresh', as: :refresh
      end
      namespace :user_dashboard do
        get 'todo_lists', as: :todo_lists
      end
      get 'csrf_token', to: 'csrf_token#show'
    end
  end
end
