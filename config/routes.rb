Dudefest::Application.routes.draw do
  resources :movies, :articles do
    resources :comments
  end

  get 'about', to: 'about#index'
  get 'contribute', to: 'contribute#index'
  get 'coming_soon', to: 'coming_soon#index'
  get 'info', to: 'info#index'
  get 'legal', to: 'legal#index'

  mount Rich::Engine => '/rich', :as => 'rich'
  mount Ckeditor::Engine => '/ckeditor'
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  devise_for :users
  resources :users, only: [:show, :index]

  get "home/index"

  get '/:id', to: 'columns#show', as: 'column'

  root "home#index"
end
