require_relative 'lib/first'
require_relative 'lib/second'

second = Second.new
first = First.new
first.trigger_test_service
second.trigger_test_service