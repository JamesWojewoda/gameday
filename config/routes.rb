Rails.application.routes.draw do
  resources :videos do
    collection do
      get :get_videos
    end
  end
end
