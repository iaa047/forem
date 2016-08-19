Forem::Engine.routes.draw do
  root 'forums#index'

  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  resources :forums, param: :permalink, only: [:show, :index], concerns: :paginatable do
    resources :topics, param: :permalink, except: [:index], concerns: :paginatable do
      resources :posts, except: [:index], concerns: :paginatable
    end
  end

  namespace :admin do
    root 'dashboard#index'
    resources :forums, except: [:show], concerns: :paginatable do
      resources :topics, except: [:show], concerns: :paginatable do
        resources :posts, except: [:show], concerns: :paginatable
      end
    end
  end
end
