require_relative 'lib/first'

first = First.new

loop do
  first.trigger_test_service
  sleep 3
end
