# rails-boilerplate

Rails アプリケーションテンプレート (`template.rb`)。`rails new` 時に読み込むだけで、以下が一気にセットアップされます。

- **RSpec** + **FactoryBot**
- **SimpleCov** によるカバレッジ計測 (line coverage **90% 未満で exit code 2**)
- **Tailwind CSS** (公式 `tailwindcss-rails`)
- **mission_control-jobs** を `/jobs` にマウント (Solid Queue ジョブ管理 UI)

## 使い方

### 新しいアプリを作る場合

```bash
rails new myapp --css tailwind -T -m https://raw.githubusercontent.com/webuilder240/rails-boilerplate/main/template.rb
```

ローカルに clone 済みなら:

```bash
rails new myapp --css tailwind -T -m /path/to/rails-boilerplate/template.rb
```

オプションの意味:

| オプション         | 役割                                            |
| ------------------ | ----------------------------------------------- |
| `--css tailwind`   | 公式 `tailwindcss-rails` をセットアップ         |
| `-T`               | Minitest をスキップ (RSpec を使うため)          |
| `-m <path or URL>` | このテンプレート (`template.rb`) を適用         |

### 既存のアプリに適用する場合

```bash
bin/rails app:template LOCATION=https://raw.githubusercontent.com/webuilder240/rails-boilerplate/main/template.rb
```

## セットアップ後のコマンド

```bash
# テスト実行 + カバレッジレポート生成
bundle exec rspec
# → coverage/index.html がレポート
# → line coverage が 90% 未満なら SimpleCov が exit code 2 で失敗

# 開発サーバー起動 (Tailwind watcher 込み)
bin/dev

# Jobs UI
# http://localhost:3000/jobs
```

## カバレッジ閾値の変更

`spec/spec_helper.rb` の先頭にある SimpleCov 設定を編集してください。

```ruby
SimpleCov.start "rails" do
  enable_coverage :branch
  minimum_coverage line: 90   # ← この値を変更
  add_filter "/spec/"
  add_filter "/config/"
  add_filter "/db/"
  add_filter "/bin/"
  add_filter "/vendor/"
end
```

## 要件

- Ruby 3.2 以上 (Rails 8.x の要件に準拠)
- Rails 8.x
