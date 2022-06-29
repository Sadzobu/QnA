Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions, only: %i[index show new create destroy update] do
    resources :answers, shallow: true, only: %i[create destroy update] do
      patch :mark_as_best, on: :member
    end
  end
end
