require 'sidekiq/web'

Rails.application.routes.draw do
  resources :subtitles
  resources :comments
  get '/movies/:imdb_code', to: 'movies#show', as: 'movie'
  get '/movies/refresh_part/:tid', to: 'movies#refresh_part'
  namespace :admin do
    resources :announcements
    resources :movies
    resources :services
    resources :torrents
    resources :users
    resources :comments
    resources :watched_movies
    resources :subtitles

    root to: "users#index"
  end
  get '/privacy', to: 'home#privacy'
  get '/terms', to: 'home#terms'
    authenticate :user, lambda { |u| u.admin? } do
      mount Sidekiq::Web => '/sidekiq'
    end

  get '/accounts/:id', to: 'accounts#show', as: 'account'
  post '/locale/edit', to: 'locale#change_locale'

  post '/searchs', to: 'searchs#index', as: 'searchs'

  post '/torrents/download/:id', to: 'torrents#download', as: 'download'
  get '/streams/:torrent_id', to: 'streams#index', as: 'stream'

  post '/comments', to: 'comments#create'

  post '/workers', to: 'home#workers', as: 'worker'

  resources :notifications, only: [:index]
  resources :announcements, only: [:index]
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", registrations: 'users/registrations' }
  root to: 'home#index'

  # get '*path' => redirect('/')
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
