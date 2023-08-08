class Item < ApplicationRecord
  belongs_to :user
  belongs_to :item_category
  belongs_to :item_condition
  belongs_to :shipping_payer_type
  belongs_to :prefecture
  belongs_to :shipping_day_type

  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_one :order, dependent: :restrict_with_error

  validates :images, presence: true
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true

  mount_uploaders :images, ImageUploader

  #検索用のホワイトリスト設定
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "images", "item_category_id", "item_condition_id", "name", "prefecture_id", "price", "shipping_day_type_id", "shipping_payer_type_id", "updated_at", "user_id"]
  end

  #検索用のホワイトリスト設定
  def self.ransackable_associations(auth_object = nil)
    ["comments", "favorites", "item_category", "item_condition", "order", "prefecture", "shipping_day_type", "shipping_payer_type", "user"]
  end

end
