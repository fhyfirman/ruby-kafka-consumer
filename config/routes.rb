Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'kafka/index'
    end
  end

  namespace :api do
    namespace :v1 do
      get 'kafka/show'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
