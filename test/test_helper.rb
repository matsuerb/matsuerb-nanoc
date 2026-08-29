require 'bundler'

Bundler.require(:default, :test)

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

require 'minitest/autorun'
