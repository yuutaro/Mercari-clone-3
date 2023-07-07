Rails.application.routes.draw do
  devise_for :users, controllers: {
    confrimations: 'users/confirmations',
    passwords: 'users/passwords',
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    unlocks: 'users/unlocks'
  }
  root to: "home#index"

  devise_scope :user do
    get "users/registrations/complete" => "users/registrations#complete"
  end

  # 単数形に注意　/user_information/:id とはならない
  # /user_information となる
  # new_user_information_path  GET    /user_information/new(.:format)  user_informations#new
  # user_information_path      POST   /user_information(.:format)      user_informations#create
  resource :user_information

  # new_user_mobile_phone_path GET   /user_mobile_phone/new(.:format)  user_mobile_phones#new
  # user_mobile_phone_path     POST  /user_mobile_phone(.:format)      user_mobile_phones#create
  resource :user_mobile_phone, only: [:new, :create] do
    collection do
      # verification_user_mobile_phones_path GET /user_mobile_phone/verification(.:format) user_mobile_phones#verification
      get :verification
      # verification_user_mobile_phones_path POST /user_mobile_phone/verification(.:format) user_mobile_phones#verification
      post :verification
    end
  end

  # item_favorites_path POST   /items/:item_id/favorites(.:format)  favorites#create
  # item_favorite_path  DELETE /items/:item_id/favorites(.:format)  favorites#destroy
  resources :items do
    resources :favorites, only: %i[create destroy], param: :item_id, shallow: true
    # item_comments_path  POST   /items/:item_id/comments(.:format)   comments#create
    # comment_path        DELETE /comments/:id(.:format)              comments#destroy
    resources :comments, only: %i[create destroy], shallow: true do
      # comment_reports_path    POST /comments/:comment_id/reports(.:format)     reports#create
      # new_comment_report_path GET  /comments/:comment_id/reports/new(.:format) reports#new
      resources :reports, only: %i[new create]
    end
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
