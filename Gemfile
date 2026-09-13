source "https://rubygems.org"

gem "nanoc", "~> 4.14"
gem "rack"
gem "mime-types"
gem "kramdown"
gem "builder"
gem "adsf"
gem "minigit"
gem "icalendar"
gem "puma"

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
