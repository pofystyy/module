require_relative 'base_storage'
require 'singleton'
require 'redis'
require 'byebug'

module LightningModule
  module Storages
    class Redis < BaseStorage
      include Singleton

      def initialize
        @db = ::Redis.new
      end

      def find_data_for_broadcast(service_name, event_name)
        service_data = find(service_name, event_name)
        delete(service_name)
        service_data
      end

      def insert_service_data(key, *values)
        add_to_db(key, values)
        service_names('service', key)
      end

      def insert(key, *values)
        add_to_db(key, values)
      end

      def find_all(service)
        @db.smembers(service)
      end

      def find_data_for_triggered(global_key, finding_key)
        find(global_key, finding_key)
      end

      def expose_methods(global_key, finding_key)
        find(global_key, finding_key)
      end

      def data_for_check_result(global_key, finding_key)
        find(global_key, finding_key)
      end

      def delete(service_name)
        @db.del(service_name)
      end

      private

      def find(global_key, finding_key)
        result = @db.hget(global_key, finding_key)
        Marshal.load(result) unless result.nil?
      end

      def service_names(service, key)
        @db.sadd(service, key)
      end

      def add_to_db(key, values)
        @db.hmset(key, values.map.with_index { |val, ind| (ind.even? ? val : Marshal.dump(val)) })
      end
    end
  end
end
