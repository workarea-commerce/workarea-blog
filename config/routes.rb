Workarea::Admin::Engine.routes.draw do
  scope '(:locale)', constraints: Workarea::I18n.routes_constraint do
    resources :content_blogs do
      resources :comments, except: :new
      get :unsubscribe, to: 'comments#unsubscribe'

      get :create_entry, to: 'create_content_blog_entries#new'
      resources :blog_entries, controller: 'content_blog_entries', only: :index
    end

    # named to prevent conflict with nested (commentable) comments resource above
    resources :content_blog_comments, as: :content_blog_user_comments, only: %i[index edit update destroy]

    resources :content_blog_entries, only: %i[index show edit update destroy] do
      resources :comments, controller: 'content_blog_comments', only: :index

      member do
        get :thumbnail_image
        put :update_thumbnail_image
      end
    end

    resources :create_content_blog_entries, except: %i[index show] do
      member do
        get :thumbnail_image
        post :save_thumbnail_image

        get :content
        post :save_content

        get :featured_products

        get :publish
        post :save_publish
      end
    end
  end
end

Workarea::Storefront::Engine.routes.draw do
  scope '(:locale)', constraints: Workarea::I18n.routes_constraint do
    get 'blogs/:id/tagged/:tag', to: 'blogs#show', as: :blog_tagged

    resources :blogs, only: %i[index show]

    resources :blog_entries, only: :show do
      get 'comments', to: 'blog_comments#index', as: :comments
      post 'comment', to: 'blog_entries#add_comment'
    end
  end
end
