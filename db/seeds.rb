# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

app = Rpush::Apns::App.new
app.name = "FeelingCall"   #一意なアプリ名
app.certificate = File.read("/path/to/sandbox.pem") # サーバ側の証明書
app.environment = "sandbox" # APNsの環境 開発環境なら"sandbox" 本番環境であれば"production"
app.password = "certificate password" # 証明書のパスワード
app.connections = 1 # APNsへのコネクション数(※DBへのコネクションも増えるので注意!)
app.save!