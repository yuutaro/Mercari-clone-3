class UserTransferHistory < ApplicationRecord
  belongs_to :user

  validates :price, presence: true
  validates :bank_name, presence: true
  validates :bank_account_name, presence: true
  validates :bank_account_kind, presence: true
  validates :bank_account_branch_name, presence: true
  validates :bank_account_number, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 500 }

  validate :price_less_than_user_earning

  enum bank_account_kind: {
    saving: 1,
    checking: 2
  }

  class << self
    def bank_account_kinds_i18n
      I18n.t("enums.user_transfer_history.kind")
    end
  end

  def bank_account_kind_i18n
    self.class.bank_account_kinds_i18n[bank_account_kind.to_sym]
  end

  #user_earningから金額を減らす処理
  def request_transfer!
    transaction do
      save!
      if user.user_earning.price == nil
        user.user_earning.price == 0
      end

      user.user_earning.price -= price
      user.user_earning.save!
    end
  rescue ActiveRecord::RecordInvalid => e
    false
  end

  private

  def price_less_than_user_earning
    return unless price.presence
    return if price <= user.user_earning&.price.to_i

    errors.add(
      :price,
      "は#{user.user_earning.price}以下である必要があります"
    )
  end
end
