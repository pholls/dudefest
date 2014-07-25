Dudefest::Application.routes.draw do
  resources :movies, :articles do
    resources :comments
  end

  resources :tips
  resources :daily_videos

  get 'about', to: 'about#index'
  get 'contribute', to: 'contribute#index'
  get 'coming_soon', to: 'coming_soon#index'
  get 'info', to: 'info#index'
  get 'legal', to: 'legal#index'
  get 'topics/:id', to: 'topics#show', as: 'topic'
  get 'feedback', to: 'feedback#index'
  post 'send_feedback', to: 'feedback#send_feedback'

  mount Rich::Engine => '/rich', :as => 'rich'
  mount Ckeditor::Engine => '/ckeditor'
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  devise_for :users
  resources :users, only: [:show, :index]

  get "home/index"

  get 'columns', to: 'columns#index'
  get '/:id', to: 'columns#show', as: 'column'

  root "home#index"
end
