Rails.application.routes.draw do
  resources :locations, only: :index

  root 'locations#index'

  mount GovukAdminTemplate::Engine, at: '/style-guide'
end
