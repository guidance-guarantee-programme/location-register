Rails.application.routes.draw do
  namespace :api, constraints: { format: :json } do
    namespace :v1 do
      get '/booking_locations/:uid', to: 'booking_locations#show', as: :booking_location
    end
  end

  resources :locators, only: :index
  resources :locations, only: :index

  post 'twilio' => 'twilios#show'

  namespace :admin do
    resources :locations, only: [:index, :update, :show, :edit]
    resources :edited_locations, only: [:index]
    root 'locations#index'
  end

  root 'locators#index'

  mount GovukAdminTemplate::Engine, at: '/style-guide'
end
