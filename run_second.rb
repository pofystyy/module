require_relative 'lib/second'

second = Second.new

loop do
  second.trigger_test_service
  sleep 3
end
