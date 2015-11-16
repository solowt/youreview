Rails.application.routes.draw do
  devise_for :users
  root :to => "reviews#index"
  get 'reviews/albums', :to => 'reviews#indexalbums'
  get 'reviews/books', :to => 'reviews#indexbooks'
  resources :reviews
end
