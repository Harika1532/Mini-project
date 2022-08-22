Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :users, only: [:create,:show,:update]
  get 'users', to: 'users#show'
  get '/users/myarticles', to: 'articles#myarticles'
  
  resources :articles do
    resources :comments
  end
  put '/articles/:id/approve', to: 'articles#approve' 
  resources :categories 
  
  # Defines the root path route ("/")
  # root "articles#index"
end
# localhost:3000/users/3/articles?approved=true
# articles?approved=false&user_id=1