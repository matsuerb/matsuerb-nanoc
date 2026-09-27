require 'bundler'

Bundler.require(:default, :test)

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))
$LOAD_PATH.unshift(File.expand_path('../lib/commands', __dir__))

require 'minitest/autorun'
