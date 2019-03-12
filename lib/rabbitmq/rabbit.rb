require "bunny" 

module RabbitModule
  def broadcast(name, data)
    service_name = self.class.current_service_name

    connection = Bunny.new 
    connection.start
    channel  = connection.create_channel
    exchange = channel.default_exchange

    queue = channel.queue("#{service_name}_#{name.to_s}", :auto_delete => true)      
    exchange.publish("#{name.to_s} #{data}", :routing_key => queue.name)
    connection.close
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def service_name(name)
      @service_data = {}
      @service_data[:service_name] = name.to_s
      @service_data[:class] = self
    end

    def current_service_name
      @service_data[:service_name]
    end

    def on(event)
      @event_data = event
      @service_name, @event_name = @event_data.keys.join.split /:/
      @method = @event_data.values.join

      connection = Bunny.new 
      connection.start
      channel  = connection.create_channel
      exchange = channel.default_exchange

      queue = channel.queue("#{@service_name}_#{@event_name}", :auto_delete => true)
      queue.subscribe do |delivery_info, metadata, payload|
        event_name, event_data = payload.split
        self.new.send(@method, event_data)
      end
      connection.close
    end
  end
end