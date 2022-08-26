Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :users, only: [:create,:show,:update]
  get 'users', to: 'users#show'
  # get '/users/myarticles', to: 'articles#myarticles'
  
  resources :articles do
    resources :comments
  end
  get '/myarticles', to: 'articles#myarticles'
  delete '/articles', to: 'articles#destroy_ids'
  put '/articles/:id/approve', to: 'articles#approve'
  put '/articles/:id/like', to: 'likes#upvote'
  put '/articles/:id/dislike', to: 'likes#downvote'
  put '/articles/:id/recover', to: 'articles#recover'
  get '/allarticles',  to: 'articles#allarticles'
  resources :articles do
    resources :categories
  end
  put '/articles/:id/categories', to: 'categories#update'
  get 'categories', to: 'categories#index'

  resources :articles do
    resources :likes
  end

  get 'liked_articles', to: 'likes#liked_articles'
  get '/articles/:id/liked_users', to: 'likes#liked_users'
  

  # get '/categories/:id', to: 'categories#show'

  put '/articles/:id/categories', to: 'categories#update'

  # resource :article_categerios
  # resources :sample, only: [:index]
  # get '/sample', to: 'sample#test'
  # Defines the root path route ("/")
  # root "articles#index"
end
# localhost:3000/users/3/articles?approved=true
# articles?approved=false&user_id=1