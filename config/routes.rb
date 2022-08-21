Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :users, only: [:create,:show,:update]
  get 'users', to: 'users#show'
  

  
  get '/users/:id/myarticles', to: 'articles#myarticles'
  get '/users/:id/approved', to: 'articles#approved'
  # put '/users/:id', to: 'users#update'
  # put '/users/:id/articles/:id/approve', to: 'articles#approve' 
  #get '/users/:id', to: 'users#index'
  resources :articles do
    resources :comments
  end
  #get '/articles/:id', to: 'articles#show'
  # put '/articles/:id', to: 'articles#update'
  put '/articles/:id/approve', to: 'articles#approve' 
  # delete 'users/articles/:id', to: 'articles#destroy'
  # resource :sample
  resources :categories 
  # get '/categories/:id', to: 'categories#show'

  # put '/categories/:id', to: 'categories#update'

  # resource :article_categerios
  # resources :sample, only: [:index]
  # get '/sample', to: 'sample#test'
  # Defines the root path route ("/")
  # root "articles#index"
end
# localhost:3000/users/3/articles?approved=true
# articles?approved=false&user_id=1