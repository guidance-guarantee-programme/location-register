require 'sidekiq/web'

Rails.application.routes.draw do
  namespace :api, constraints: { format: :json } do
    namespace :v1 do
      get '/booking_locations/:uid', to: 'booking_locations#show', as: :booking_location
      get '/twilio_numbers', to: 'twilio_numbers#index', as: :twilio_numbers
    end
  end

  resources :locators, only: :index
  resources :locations, only: :index

  post 'twilio' => 'twilios#show'
  get 'twilio' => 'twilios#show'
  get 'twilio/handle_status' => 'twilios#handle_status', as: :twilio_handle_status

  namespace :admin do
    resources :locations, except: :destroy do
      get 'online_booking', on: :member

      resources :guiders, only: %i(index create)
    end

    resources :edited_locations, only: [:index]
    root 'locations#index'
  end

  root 'locators#index'

  mount GovukAdminTemplate::Engine, at: '/style-guide'

  mount Sidekiq::Web, at: '/sidekiq', constraints: AuthenticatedUser.new
end
