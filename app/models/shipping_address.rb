class ShippingAddress < ApplicationRecord
  belongs_to :user
  belongs_to :prefecture

  ZENKAKU_REGEX = /\A(?:\p{Hiragana}|\p{Katakana}|[ー－]|[一-龠々])+\z/
  ZENKAKU_KANA_REGEX =  /\A[ァ-ヶー－]+\z/

  validates :family_name,        presence: :true, format: { with: ZENKAKU_REGEX, message: '全角文字を使用してください' }, allow_blank: true
  validates :given_name,         presence: :true, format: { with: ZENKAKU_REGEX, message: '全角文字を使用してください' }, allow_blank: true
  validates :family_name_kana,   presence: :true, format: { with: ZENKAKU_KANA_REGEX, message: '全角カタカナを使用してください' }, allow_blank: true
  validates :given_name_kana,    presence: :true, format: { with: ZENKAKU_KANA_REGEX, message: '全角カタカナを使用してください' }, allow_blank: true
  validates :postal_code,        presence: :true  # 郵便番号
  validates :city,               presence: :true
  validates :line,               presence: :true
  validates :building_name,      presence: :true
  validates :phone_number,       presence: :true

  def full_name
    "#{family_name} #{given_name}"
  end

  def display_postal_code
    postal_code.to_s.insert(3, '-')
  end

  def address
    "#{prefecture.name} #{city} #{line} #{building_name}"
  end
end
