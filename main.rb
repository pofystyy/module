require_relative 'lib/first'
require_relative 'lib/second'
require_relative 'lib/storage/redis'

second = Second.new
first = First.new
first.trigger_test_service
second.trigger_test_service
