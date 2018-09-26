Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'register', to: 'users#register'
      post 'login', to: 'users#login'

      resources :books do
        collection do
          get 'my_books'
          get 'newest_books'
        end

        member do
          patch 'update_book_cover'
        end
      end
      resources :loans, only: [:create, :update, :destroy] do
        collection do
          get 'other_requests'
          get 'my_requests'
        end
      end
    end
  end
end
