Rails.application.routes.draw do
  mount API::Base => '/'
  # namespace :api do
  #   namespace :v1 do
  #     get '/reviews', to: 'reviews#index'
  #   end
  # end
end
