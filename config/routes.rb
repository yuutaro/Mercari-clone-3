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

    resources :favorites, only: %i[create]
     # item_favorites_path POST   /items/:item_id/favorites(.:format)  favorites#create
     
    delete "favorites", to: "favorites#destroy", as: :favorite
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

    resources :shipping_addresses
    # item_shipping_addresses_path         GET     /items/:item_id/shipping_addresses(.:format)          shipping_addresses#index
    # item_shipping_addresses_path         POST    /items/:item_id/shipping_addresses(.:format)          shipping_addresses#create
    # new_item_shipping_addresses_path     GET     /items/:item_id/shipping_addresses/new(.:format)      shipping_addresses#new
    # edit_item_shipping_addresses_path    GET     /items/:item_id/shipping_addresses/:id/edit(.:format) shipping_addresses#edit
    # item_shipping_address_path           GET     /items/:item_id/shipping_addresses/:id(.:format)      shipping_addresses#show
    # item_shipping_address_path           PATCH   /items/:item_id/shipping_addresses/:id(.:format)      shipping_addresses#update
    # item_shipping_address_path           PUT     /items/:item_id/shipping_addresses/:id(.:format)      shipping_addresses#update
    # item_shipping_address_path           DELETE  /items/:item_id/shipping_addresses/:id(.:format)      shipping_addresses#destroy

    resource :current_shipping_address, only: %i[update]
    # item_current_shipping_address_path   PATCH   /items/:item_id/current_shipping_address(.:format) current_shipping_addresses#update
    # item_current_shipping_address_path   PUT     /items/:item_id/current_shipping_address(.:format) current_shipping_addresses#update

    resources :orders, only: %i[new create show], shallow: true do
    # item_orders_path      POST  /items/:item_id/orders(.:format)      orders#create
    # new_item_order_path   GET   /items/:item_id/orders/new(.:format)  orders#new
    # item_order_path       GET   /items/:item_id/orders/:id(.:format)  orders#show
      resources :messages, only: %i[create]
      # order_messages_path POST  /orders/:order_id/messages(.:format)  messages#create
      member do
        post :ship
        # ship_order_path  POST   /orders/:id/ship(.:format)   orders#ship
      end
      resource :payer_evaluation, only: %i[create]
      # order_payer_evaluation_path  POST   /orders/:order_id/payer_evalution(.:format)   payer_evalutions#create

      resource :seller_evaluation, only: %i[create]
      # order_seller_evaluation_path POST   /orders/:order_id/seller_evaluation(.:format) seller_evaluation#create
    end
  end
  resources :users, only: %i[show] do
  # user_path   GET  /user/:id(.:format)   users#show

    resources :evaluations, only: %i[index]
    # user_evaluations_path   GET  /user/:user_id/evaluations(.:format)   evaluations#index
  end
  get "mypage" => "mypage#index"
  # mypage_path  GET  /mypage(.:format)   mypage#index
  namespace :mypage do
    resources :favorites, only: %i[index destroy]
    # mypage_favorites_path    GET      /mypage/favorites(.:format)       mypage/favorites#index
    # mypage_favorite_path     DELETE   /mypage/favorites/:id(.:format)   mypage/favorites#destroy
    
    resources :items, only: %i[index]
    # mypage_items_path        GET      /mypage/items(.:format)           mypage/items#index
    namespace :items do
      get "in_progress" => "in_progress#index", as: :in_progress
      # mypage_items_in_progress_path  GET   /mypage/items/in_progress(.:format)
    end
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?





end
