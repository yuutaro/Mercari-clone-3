Rails.application.routes.draw do
  devise_for :users, controllers: {
    confrimations: 'users/confirmations',
    passwords: 'users/passwords',
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    unlocks: 'users/unlocks'
  }
  root to: "home#index"

  # 単数形に注意　/user_information/:id とはならない
  # /user_information となる
  resource :user_information

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
