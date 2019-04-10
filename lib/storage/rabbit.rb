require_relative 'base_storage'
require 'singleton'
require 'bunny'
require 'byebug'

module LightningModule
  module Storages
    class Rabbit < BaseStorage
      include Singleton

      def initialize
        @connection = Bunny.new
      end

      def find_data_for_broadcast(service_name, event_name)
        eval(find(service_name).uniq.join)[event_name] rescue ''
      end

      def insert_service_data(key, *values)
        add_queue(key, values)
        service_name_queue(key)
      end

      def insert(key, *values)
        add_queue(key, values)
      end

      def find_all(key)
        bunny_connect_subscribe(key)
        @output
      end

      def find_data_for_triggered(global_key, finding_key)
        bunny_connect_subscribe(global_key)
        data = eval(@output.join) rescue ''
        [data[finding_key], data['from']] rescue ''
      end

      def expose_methods(global_key, finding_key = nil)
        bunny_connect_subscribe(global_key)
        eval(@output.join.sub('}{', '}|{').split('|').uniq.join)[finding_key] rescue ''
      end

      def data_for_check_result(global_key, finding_key = nil)
        bunny_connect_subscribe(global_key)
        eval(@output.join.sub('}{', '}|{').split('|').uniq.join)[finding_key] rescue ''
      end

      def destroy(service_name)
        bunny_connect_subscribe(service_name)
      end

      private

      def find(global_key, finding_key = nil)
        bunny_connect_subscribe(global_key)
        @output
      end

      def add_queue(key, values)
        bunny_connect_publish(key, Hash[*values])
      end

      def service_name_queue(key)
        bunny_connect_publish('service', key)
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
        @output = []
        @connection.start
        channel  = @connection.create_channel
        exchange = channel.direct("lightning_module", :auto_delete => true)
        queue = channel.queue(queue_name, :auto_delete => true, :durable => true).bind(exchange, :routing_key => queue_name)
        queue.subscribe do |delivery_info, metadata, payload|
          @output << payload
        end
        # channel.queue_delete(queue='queue_name')
        # channel.queue_delete(queue=)
        @connection.close
      end
    end
  end
end
