class User < ApplicationRecord
  devise  
          #認証機能
          :database_authenticatable,
          #新規登録機能
          :registerable,
          #パスワードリセット機能
          :recoverable,
          #ログイン状態保持機能
          :rememberable,
          #バリデーション機能
          :validatable,
          #メールアドレス認証機能
          :confirmable,
          #アカウントロック機能
          :lockable,
          #ログイン保持機能
          :timeoutable,
          #ログイン時のIPなどの記録機能
          :trackable

  validates :nickname,   presence: true
  validates :gender,     presence: true
  before_validation :skip_confirmation!, if: :new_record?
  after_create :create_stripe_customer

  has_one :user_information, dependent: :destroy
  has_one :user_mobile_phone, dependent: :destroy
  has_one :stripe_customer, dependent: :destroy
  has_one :current_shipping_address, dependent: :destroy


  has_many :items, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :shipping_addresses, dependent: :destroy

  enum gender: {
    unanswered: 0,
    male: 1,
    female: 2
  }

  #gendersの国際化されたバージョンを取得するクラスメソッド
  class << self
    def genders_i18n
      I18n.t("enums.user.gender")
    end
  end

  def evaluations
    #Evaluationモデルに対してクエリを実行
    Evaluation
      #orderモデルとitemモデルとの関連を結合
      .joins(order: :item)
      #特定のユーザーに対する評価の絞り込み
      .where(<<~SQL, order_user_id: self.id, item_user_id: self.id)
      /*条件*/
      (
        /*EvaluationsモデルのtypeがSellerEvaluationである場合*/
        evaluations.type = 'SellerEvaluation'
        AND
        /*ordersモデルのuser_idがorder_user_idである場合*/
        orders.user_id = :order_user_id
      )
      OR
      (
        /*EvaluationsモデルのtypeがPayerEvaluationである場合*/
        evaluations.type = 'PayerEvaluation'
        AND
        /*itemssモデルのuser_idがitem_user_idである場合*/
        items.user_id = :item_user_id
      )
    SQL
  end

  #ログイン状態を保持するメソッド
  def remember_me
    #常にtrueを返す
    true
  end

  #いいねしているか判定するメソッド
  def liked?(item)
    favorites.exists?(item: item)
  end

end
