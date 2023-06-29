class UserInformation < ApplicationRecord
  belongs_to :user

  # 全角ひらがな、全角カタカナ、漢字のみ　正規表現　定数
  ZENKAKU_REGEXP =  /\A(?:\p{Hiragana}|\p{Katakana}|[ー－]|[一-龠々])+\z/
  # 全角カナのみ　正規表現　定数
  ZENKAKU_KANA_REGEXP =  /\A[ァ-ヶー－]+\z/

  validates :family_name,       presence: true
  validates :family_name,       format: { with: ZENKAKU_REGEXP, message: "全角文字を使用してください" }
  validates :given_name,        presence: true
  validates :given_name,        format: { with: ZENKAKU_REGEXP, message: "全角文字を使用してください" }
  validates :family_name_kana,  presence: true
  validates :family_name_kana,  format: { with: ZENKAKU_KANA_REGEXP, message: "全角カタカナを使用してください" }
  validates :given_name_kana,   presence: true
  validates :given_name_kana,   format: { with: ZENKAKU_KANA_REGEXP, message: "全角カタカナを使用してください" }
  validates :birth_date,        presence: true

end
