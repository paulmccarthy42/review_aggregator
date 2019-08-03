Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/reviews', to: 'reviews#index'
    end
  end
end
