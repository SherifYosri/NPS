require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  scope 'api/v1' do
    devise_for :users, skip: :all

    as :user do
      post 'sessions', to: 'v1/sessions#create'
    end

    resources :feedbacks, controller: "v1/feedbacks", only: [:create, :index]
  end
end
