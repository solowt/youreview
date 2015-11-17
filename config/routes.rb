Rails.application.routes.draw do
  post '/rate' => 'rater#create', :as => 'rate'
  devise_for :users
  root :to => "reviews#index"
  resources :albumreviews, :except => ['create']
  resources :reviews do
    resources :comments, :except => ['index', 'show']
  end
  get 'works/:id/show', to: 'works#show'
  get 'works/:work_id/:work_index', to: 'works#select'
  resources :works do
    resources :albumreviews, :except => ['index', 'destroy' , 'show', 'edit', 'update']
  end
end
