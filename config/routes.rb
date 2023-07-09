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

  resource :user_information
  # 単数形に注意　/user_information/:id とはならない
  # /user_information となる
  # new_user_information_path   GET    /user_information/new(.:format)   user_informations#new
  # edit_user_information_path  GET    /user_information/edit(.:format)  user_informations#edit
  # user_information_path       GET    /user_information(.:format)       user_informations#show
  # user_information_path       PATCH  /user_information(.:format)       user_informations#update
  # user_information_path       PUT    /user_information(.:format)       user_informations#update
  # user_information_path       DELETE /user_information(.:format)       user_informations#destroy
  # user_information_path       POST   /user_information(.:format)       user_informations#create


  resource :user_mobile_phone, only: [:new, :create] do
  # new_user_mobile_phone_path GET   /user_mobile_phone/new(.:format)  user_mobile_phones#new
  # user_mobile_phone_path     POST  /user_mobile_phone(.:format)      user_mobile_phones#create
  
    collection do
      # verification_user_mobile_phones_path GET /user_mobile_phone/verification(.:format) user_mobile_phones#verification
      get :verification
      # verification_user_mobile_phones_path POST /user_mobile_phone/verification(.:format) user_mobile_phones#verification
      post :verification
    end
  end


  resources :items do
  # items_path     GET    /items(.:format)          items#index
  # items_path     POST   /items(.:format)          items#create
  # new_item_path  GET    /items/new(.:format)      items#new
  # edit_item_path GET    /items/:id/edit(.:format) items#edit
  # item_path      GET    /items/:id(.:format)      items#show
  # item_path      PATCH  /items/:id(.:format)      items#update
  # item_path      PUT    /items/:id(.:format)      items#update
  # item_path      DELETE /items/:id(.:format)      items#destroy

    resources :favorites, only: %i[create destroy], param: :item_id, shallow: true
    # item_favorites_path POST   /items/:item_id/favorites(.:format)  favorites#create
    # item_favorite_path  DELETE /items/:item_id/favorites(.:format)  favorites#destroy

    resources :comments, only: %i[create destroy], shallow: true do
    # item_comments_path  POST   /items/:item_id/comments(.:format)   comments#create
    # comment_path        DELETE /comments/:id(.:format)              comments#destroy

      resources :reports, only: %i[new create]
      # comment_reports_path    POST /comments/:comment_id/reports(.:format)     reports#create
      # new_comment_report_path GET  /comments/:comment_id/reports/new(.:format) reports#new
    end
    resources :stripe_payments, only: %i[index new destroy]
    # item_stripe_payments_path            GET     /items/:item_id/stripe_payments(.:format)        stripe_payments#index
    # new_item_stripe_payment_path         GET     /items/:item_id/stripe_payments/new(.:format)    stripe_payments#new
    # item_stripe_payment_path             DELETE  /items/:item_id/stripe_payments/:id(.:format)    stripe_payments#destroy

    get "stripe_payments/create" => "stripe_payments#create", as: :get_create_stripe_payments
    # item_get_create_stripe_payments_path GET     /items/:item_id/stripe_payments/create(.:format) stripe_payments#create

    resource :current_stripe_payment, only: %i[update]
    # item_current_stripe_payment_path     PATCH   /items/:item_id/current_stripe_payment(.:format) current_stripe_payments#update
    # item_current_stripe_payment_path     PUT     /items/:item_id/current_stripe_payment(.:format) current_stripe_payments#update

  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
