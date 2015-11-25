Rails.application.routes.draw do
  post '/rate' => 'rater#create', :as => 'rate'
  devise_for :users
  root :to => "reviews#index"
  resources :albumreviews, :except => ['create']
  resources :bookreviews do # NHO: Why did you need these custom route defintions and not resources :comments?
    get 'comments/new', to: 'comments#new_book_comment'
    post 'comments/post', to: 'comments#post_book_comment'
    delete 'comments/:id', to: 'comments#destroy_book_comment'
  end
  resources :reviews do
    resources :comments, :except => ['index', 'show']
  end
  get 'works/:id/show', to: 'works#show'  # NHO: What are purpose of these two custom routes for works?
  get 'works/:work_id/:work_index', to: 'works#select'
  resources :works do
    resources :albumreviews, :except => ['index', 'destroy' , 'show', 'edit', 'update']
  end
end
