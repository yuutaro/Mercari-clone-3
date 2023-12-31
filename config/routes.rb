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
    resources :favorites, only: [:create]
    delete "favorites", to: "favorites#destroy", as: :favorite
    resources :comments, only: [:create, :destroy], shallow: true do
      resources :reports, only: [:new, :create]
    end
    resources :stripe_payments, only: [:index, :new, :destroy]
    get "stripe_payments/create", to: "stripe_payments#create", as: :get_create_stripe_payments
    resource :current_stripe_payment, only: [:update]
    resources :shipping_addresses
    resource :current_shipping_address, only: [:update]
    resources :orders, only: [:new, :create, :show], shallow: true do
      resources :messages, only: [:create]                                                                  # order_messages_path              POST   /orders/:order_id/messages(.:format)              messages#create
      member do
        post :ship                                                                                          # ship_order_path                  POST   /orders/:id/ship(.:format)                        orders#ship
      end
      resource :payer_evaluation, only: [:create]                                                           # order_payer_evaluation_path      GET    /orders/:order_id/payer_evaluation/new(.:format)  payer_evaluations#new
    end
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
