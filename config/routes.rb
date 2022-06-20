Rails.application.routes.draw do
  resources :questions, only: %i[new create] do
    resources :answers, only: %i[new create]
  end
end
