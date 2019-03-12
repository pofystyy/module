require "bunny" 

module RabbitModule
  def broadcast(name, data)
    service_name = self.class.current_service_name

    connection = Bunny.new 
    connection.start
    channel  = connection.create_channel
    exchange = channel.default_exchange

    queue = channel.queue("event-#{service_name}_#{name.to_s}", :auto_delete => true)      
    exchange.publish("#{name.to_s} #{data}", :routing_key => queue.name)
    connection.close
  end

  def trigger(address, data)
    service_name, method = address.split(/\./)

    connection = Bunny.new 
    connection.start
    channel  = connection.create_channel
    exchange = channel.default_exchange

    queue = channel.queue("#{service_name}", :auto_delete => true)
    queue.subscribe do |delivery_info, metadata, payload|
      clazz, methods = payload.split
      obj = Object.const_get clazz
      obj.new.send(method, data) if methods.include? method
    end
    connection.close
  end

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def service_name(name)
      check_service_data
      @service_data[:service_name] = name.to_s
      @service_data[:class] = self
      call_create_queue
    end

    def expose(*meth)
      check_service_data
      @service_data[:methods] = meth
      call_create_queue
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

      queue = channel.queue("event-#{@service_name}_#{@event_name}", :auto_delete => true)
      queue.subscribe do |delivery_info, metadata, payload|
        event_name, event_data = payload.split
        self.new.send(@method, event_data) if @service_data[:methods].to_s.include? @method
      end
      connection.close
    end

    private

    def check_service_data
      @service_data = {} if @service_data.nil? 
    end

    def call_create_queue
      create_queue if @service_data.size == 3
    end

    def create_queue
      connection = Bunny.new 
      connection.start
      channel  = connection.create_channel
      exchange = channel.default_exchange

      queue = channel.queue("#{@service_data[:service_name]}", :auto_delete => true)      
      exchange.publish("#{@service_data[:class]} #{@service_data[:methods]}", :routing_key => queue.name)
      connection.close
    end
  end
end