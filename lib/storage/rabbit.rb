require_relative 'base_storage'
require 'singleton'
require 'bunny'

module Storages
  class Rabbit < BaseStorage
    include Singleton

    def initialize
      @connection = Bunny.new
    end

    def trigger(service_name)
      data = find(service_name)
      [data['class'.to_sym].to_s, data['methods'.to_sym]]
    end

    def on(service_name, event_name)
      find(service_name)[event_name.to_sym] rescue ''
    end

    def insert_service_data(key, *values)
      add_queue(key, values)
      service_name_queue(key)
    end   

    def insert(key, *values)
      add_queue(key, values)   
    end

    def findall(key)
      bunny_connect_subscribe(key)
      [@output]
    end

    private

    def add_queue(key, values)
      values = Hash[*values.map { |value| value.is_a?(String) ? value.to_sym : value }]

      bunny_connect_publish(key, values) 
    end

    def service_name_queue(key)
      bunny_connect_publish('service', key)
    end

    def find(global_key, finding_key = nil) 
      bunny_connect_subscribe(global_key)
      eval @output
    end

    def bunny_connect_publish(queue_name, values)
      @connection.start      
      channel  = @connection.create_channel   
      exchange = channel.direct("lightning_module", :auto_delete => true) 
      queue = channel.queue(queue_name, :auto_delete => true, :durable => true).bind(exchange, :routing_key => queue_name)
      exchange.publish("#{values}", :routing_key => queue.name)
      @connection.close  
    end

    def bunny_connect_subscribe(queue_name)
      @connection.start
      channel  = @connection.create_channel   
      exchange = channel.direct("lightning_module", :auto_delete => true) 
      queue = channel.queue(queue_name, :auto_delete => true, :durable => true).bind(exchange, :routing_key => queue_name)
      queue.subscribe do |delivery_info, metadata, payload|
        @output = payload
      end
      channel.queue_delete(queue='queue')
      @connection.close
    end
  end
end