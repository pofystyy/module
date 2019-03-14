require_relative 'lib/first'
require_relative 'lib/second'

first = First.new
second = Second.new

first.trigger_test_service
second.trigger_test_service

# => "Second: testdata"
# => "Second: my data"
# => "First: data"
