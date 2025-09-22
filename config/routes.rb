# config/routes.rb
require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq" if Rails.env.development?

  namespace :api do
    namespace :v1 do
      resources :users do
        resources :timer_registers, only: [ :index ], module: :users
        resources :reports, only: [ :create ], module: :users
      end

      resources :timer_registers, only: [ :index, :show, :create, :update, :destroy ]

      get  "reports/:uid/status",   to: "reports#status"
      get  "reports/:uid/download", to: "reports#download"
    end
  end
end
