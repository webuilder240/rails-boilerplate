# Rails Application Template
#
# Usage:
#   rails new myapp --css tailwind -T -m template.rb
#   # または既存アプリに対して:
#   bin/rails app:template LOCATION=/path/to/template.rb
#
# 注意:
#   * `--css tailwind` で公式の tailwindcss-rails をセットアップ
#   * `-T` で Minitest をスキップ (RSpec を使うため)

# ---------- Gems ----------
# Solid Queue ジョブの管理 UI (Rails 8 ではデフォルトで solid_queue が入る)
gem "mission_control-jobs"

gem_group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
end

gem_group :test do
  gem "simplecov", require: false
end

# ---------- SimpleCov (カバレッジ計測, 90% 未満でエラー) ----------
# spec_helper.rb の先頭に SimpleCov を読み込ませる。
# rails generate rspec:install より前に置いておき、後で prepend する。
SIMPLECOV_SNIPPET = <<~RUBY
  require "simplecov"
  SimpleCov.start "rails" do
    enable_coverage :branch
    minimum_coverage line: 90
    add_filter "/spec/"
    add_filter "/config/"
    add_filter "/db/"
    add_filter "/bin/"
    add_filter "/vendor/"
  end

RUBY

# ---------- .gitignore ----------
append_to_file ".gitignore", <<~GITIGNORE

  # SimpleCov
  /coverage/
GITIGNORE

# ---------- after_bundle: bundle install 後に実行 ----------
after_bundle do
  # RSpec の初期化
  generate "rspec:install"

  # Mission Control - Jobs を /jobs にマウント
  route 'mount MissionControl::Jobs::Engine, at: "/jobs"'

  # spec_helper.rb の先頭に SimpleCov の設定を差し込む
  spec_helper_path = "spec/spec_helper.rb"
  if File.exist?(spec_helper_path)
    original = File.read(spec_helper_path)
    File.write(spec_helper_path, SIMPLECOV_SNIPPET + original)
  end

  # サンプル spec (空でも minimum_coverage が機能するように)
  create_file "spec/example_spec.rb", <<~RUBY
    require "rails_helper"

    RSpec.describe "Application" do
      it "boots" do
        expect(Rails.application).to be_a(Rails::Application)
      end
    end
  RUBY

  # 初期コミット (rails new 直後のコミットに上書きしないよう新規コミット)
  git add: "."
  git commit: %(-m "Apply boilerplate template: RSpec + SimpleCov(90%) + Tailwind") rescue nil

  say "\n========================================", :green
  say "ボイラープレート適用完了", :green
  say "  - RSpec:      bin/rails spec  または  bundle exec rspec", :green
  say "  - カバレッジ: spec 実行後 coverage/index.html を確認", :green
  say "                line coverage 90% 未満で exit code 1", :green
  say "  - Tailwind:   bin/dev で起動 (foreman + Procfile.dev)", :green
  say "  - Jobs UI:    http://localhost:3000/jobs (mission_control-jobs)", :green
  say "========================================\n", :green
end
