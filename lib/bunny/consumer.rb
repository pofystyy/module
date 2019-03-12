require "bunny" 

# con
connection = Bunny.new 
connection.start

# ch
channel  = connection.create_channel

# q
queue    = channel.queue("bunny.examples.hello", :auto_delete => true)

# x
exchange = channel.default_exchange

queue.subscribe do |delivery_info, metadata, payload|
  puts "Received #{payload}"
end

# exchange.publish("Hello!", :routing_key => queue.name)

connection.close