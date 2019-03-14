require_relative 'base_storage'
require 'singleton'
require 'bunny'

module Storages
  class Rabbit < BaseStorage
    include Singleton

    def trigger(service_name, method)
      data = find(service_name)
      [data['class'.to_sym].to_s, data['methods'.to_sym]]
    end

    def on(service_name, event_name)
      find(service_name)[event_name.to_sym]
    end

    def insert(key, *values)
      values = Hash[*values.map { |value| value.is_a?(String) ? value.to_sym : value }]

      bunny_connect

      queue = @channel.queue(key, :auto_delete => true)      
      @exchange.publish("#{values}", :routing_key => queue.name)
      @connection.close    
    end

    private

    def find(global_key, finding_key = nil) 
      bunny_connect

      queue = @channel.queue(global_key, :auto_delete => true)
      queue.subscribe do |delivery_info, metadata, payload|
        @output = eval(payload)
      end
      @connection.close
      @output
    end

    private 

    def bunny_connect
      @connection = Bunny.new 
      @connection.start
      @channel  = @connection.create_channel   
      @exchange = @channel.default_exchange 
    end
  end
end