require_relative 'lib/first'
require_relative 'lib/second'

first = First.new
second = Second.new

first.trigger_test_service
second.trigger_test_service

# server = Jimson::Server.new(First.new)
# server.start

# server = Jimson::Server.new(Second.new)
# server.start

# => "Second: testdata"
# => "Second: my data"
# => "First: data"
