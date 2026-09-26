source "https://rubygems.org"

gem "nanoc", "~> 4.14"
gem "rack"
gem "mime-types"
gem "kramdown"
gem "builder"
gem "adsf"
gem "minigit"
gem "icalendar"

# nanoc live/view はRackup::Handler.defaultでpuma→falcon→webrickの順に
# 使えるものを自動選択する。pumaはnanoc-liveのCtrl+C終了時にプロセスが
# 残ってしまう既知の不具合(nanoc/nanoc#1499)があるため、webrickが
# 選ばれるように明示的に追加している(Ruby 3.0以降、標準では入らないため)。
gem "webrick"

# nanoc-cliはBundler.require(:nanoc)でこのグループのgemを自動requireして
# CLIコマンドを追加する仕組みになっているため、nanoc-liveはここに置く必要がある。
group :nanoc do
  gem "nanoc-live"
end

group :development do
  gem "bundler-audit"
  gem "rubocop", require: false
end

group :test do
  gem "minitest"
  gem "timecop"
end
