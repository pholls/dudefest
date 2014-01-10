Dudefest::Application.routes.draw do
  resources :movies, :articles

  mount Ckeditor::Engine => '/ckeditor'
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  devise_for :users

  get "home/index"

  get '/:id', to: 'columns#show', as: 'column'

  root "home#index"
end
