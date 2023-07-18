class PayerEvaluation < Evaluation
    validates :received, acceptance: { message: "にチェックを入れてください" }


    #評価者名を表示するメソッド
    def reviewer
        order.user
    end
end