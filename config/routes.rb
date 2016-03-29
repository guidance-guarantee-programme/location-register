Rails.application.routes.draw do
  resources :locations, only: [:index, :update]

  root 'locations#index'

  mount GovukAdminTemplate::Engine, at: '/style-guide'
end
