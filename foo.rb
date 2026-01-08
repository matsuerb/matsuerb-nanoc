require "bundler"
Bundler.setup
require "icalendar"

p Icalendar::Values::DateTime.new(Time.now, 'tzid' => 'JTC')
