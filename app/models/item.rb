class Item < ApplicationRecord
  belongs_to :user
  belongs_to :item_category
  belongs_to :item_condition
  belongs_to :shipping_payer_type
  belongs_to :prefecture
  belongs_to :shipping_day_type

  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :images, presence: true
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true

  mount_uploaders :images, ImageUploader
end
