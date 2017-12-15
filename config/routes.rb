Rails.application.routes.draw do

  # get 'sponsored_posts/show'
  #
  # get 'sponsored_posts/new'
  #
  # get 'sponsored_posts/edit'

  resources :topics do
    resources :posts, :sponsored_posts, except: [:index]
  end

  get 'about' => 'welcome#about'

  root 'welcome#index'

end
