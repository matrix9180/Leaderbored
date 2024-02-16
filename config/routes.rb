Rails.application.routes.draw do
  resources :leaderboards, only: [], param: :id do
    member do
      post 'scores', to: 'leaderboards#add_score', as: :add_score
      delete 'scores/:user_id', to: 'leaderboards#delete_score', as: :score
      get 'scores', to: 'leaderboards#top_scores', as: :scores
      get 'ranks/:user_id', to: 'leaderboards#rank_of', as: :rank
      delete '', to: 'leaderboards#reset', as: :reset
    end
  end
end
