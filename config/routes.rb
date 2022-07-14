Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :voteable do
    member do
      post :upvote
      post :downvote
      delete :cancel
    end
  end

  concern :commentable do
    member do
      post :create_comment
    end
  end

  resources :attachments, only: %i[destroy]
  resources :links, only: %i[destroy]
  resources :rewards, only: %i[index]

  resources :questions, concerns: %i[voteable commentable], except: %i[edit] do
    resources :answers, concerns: %i[voteable], shallow: true, only: %i[create destroy update] do
      patch :mark_as_best, on: :member
    end
  end
end
