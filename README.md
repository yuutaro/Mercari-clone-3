# README

メルカリクローン：学習中
デスクトップバージョン

# 変更歴
1. development-branch の追加　以降の開発はこのブランチから


# トラブル発生箇所
1. ch21.3
* db:migrateでパーミッションエラー
データベースのコンテナを停止ではなく破棄してからマイグレーションすると解決　\\
ActiveRecord::ConnectionNotEstablished: FATAL:  could not open file "global/pg_filenode.map": Permission denied\\
アクティブレコードがどこかのファイルにアクセス出来なくなる
# Mercari-clone-3
