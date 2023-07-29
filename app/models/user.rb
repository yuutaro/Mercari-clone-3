class User < ApplicationRecord
  #認証機能
  #新規登録機能
  #パスワードリセット機能
  #ログイン状態保持機能
  #バリデーション機能
  #メールアドレス認証機能
  #アカウントロック機能
  #ログイン保持機能
  #ログイン時のIPなどの記録機能
  devise  :database_authenticatable,
          :registerable,
          :recoverable,
          :rememberable,
          :validatable,
          :confirmable,
          :lockable,
          :timeoutable,
          :trackable

  validates :nickname,   presence: true
  validates :gender,     presence: true
  before_validation :skip_confirmation!, if: :new_record?
  after_create :create_stripe_customer

  has_one :user_information, dependent: :destroy
  has_one :user_mobile_phone, dependent: :destroy
  has_one :stripe_customer, dependent: :destroy
  has_one :current_shipping_address, dependent: :destroy
  has_one :profile, dependent: :destroy

  has_many :items, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :shipping_addresses, dependent: :destroy

  has_many :active_relationships,
    class_name: "Relationship",
    foreign_key: "follower_id",
    dependent: :destroy

  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships,
    class_name: "Relationship",
    foreign_key: "followed_id",
    dependent: :destroy

  has_many :followers, through: :passive_relationships, source: :follower

  enum gender: {
    unanswered: 0,
    male: 1,
    female: 2
  }

  #評価レート最小最大値の定義
  EVALUATION_MAX_RATE = 5
  EVALUATION_MINIMUM_RATE = 1

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

  #フォローするためのメソッド
  def follow(follow_user)
    active_relationships.create!(followed_id: follow_user.id)
  end

  #フォロー解除のためのメソッド
  def unfollow(unfollow_user)
    active_relationships.find_by!(followed_id: unfollow_user.id).destroy!
  end

  #フォロー判定のためのメソッド
  def following?(other_user)
    following.where("relationships.followed_id = ?", other_user.id).exists?
  end

  def evaluation_rate
    evaluation_mappings = evaluations.each_with_object({ good: 0, bad: 0 }) do |evaluation, result|
      #good,badそれぞれの場合にカウントを加算する
      result[:good] += 1 if evaluation.good?
      result[:bad] += 1 unless evaluation.good?
    end

    #評価の総数の算出
    evaluation_count = evaluation_mappings[:good] + evaluation_mappings[:bad]
    #good評価ポイントの算出 good評価数 × 評価最大値5
    good_total_point = evaluation_mappings[:good] * EVALUATION_MAX_RATE
    #bad評価ポイントの算出   bad評価数 × 評価最小値1
    bad_total_point = evaluation_mappings[:bad] * EVALUATION_MINIMUM_RATE
    
    #評価レート計算 小数点以下切り捨て  (good評価ポイント+bad評価ポイント)÷評価の総数
    ((good_total_point + bad_total_point) / evaluation_count).round
    #評価がない場合、0で割るエラーに対して、0を返す
    rescue ZeroDivisionError
    0
  end

end
