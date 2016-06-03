Rails.application.routes.draw do
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
