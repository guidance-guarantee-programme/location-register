Rails.application.routes.draw do
  resources :locators, only: :index
  resources :locations, only: :index

  namespace :admin do
    resources :locations, only: [:index, :update]
    root 'locations#index'
  end

  root 'admin/locations#index'

  mount GovukAdminTemplate::Engine, at: '/style-guide'
end
