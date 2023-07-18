class Evaluation < ApplicationRecord
    belongs_to :order
    validates :comment, presence: true

    #良かった評価と残念だった評価の表示制御
    scope :with_good, ->(bool) {
        if bool.nil?
        where(good: true)
        else
        where(good: bool)
        end
    }
end
