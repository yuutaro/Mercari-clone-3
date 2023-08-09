# README

メルカリクローン：学習中
デスクトップバージョン

# 変更歴
1. development-branch の追加　以降の開発はこのブランチから
2. Ayumu_dev_2 ブランチの追加

# トラブル発生箇所
1. ch21.3
* db:migrateでパーミッションエラー
データベースのコンテナを停止ではなく破棄してからマイグレーションすると解決　\\
ActiveRecord::ConnectionNotEstablished: FATAL:  could not open file "global/pg_filenode.map": Permission denied\\
アクティブレコードがどこかのファイルにアクセス出来なくなる
# Mercari-clone-3

# 追加機能
【商品検索システム(プロトタイプ)】
・作品名は、作品名nameと商品説明descriptionに含まれるワードを検索する仕様
・販売価格は、以上以下の仕様。片方空欄の場合、入力済みのformのみ検索が適用される
・カテゴリーのような、選択系は、出品formからの移植。条件として_eqで選択したカテゴリーIDと一致するものが検索される。

【ページネーション機能(プロトタイプ)】
・Gemであるkaminariを使用した
・HomeControllerで@itemsに代入する際に末尾に.page(params[:page]).per(5)を加えることで追加できる
・CSSデザインが出来ようできなく、bootstrapを使用する必要があるらしいが、難易度が高いためデザインは保留とした。