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

      def trigger(key, *values)
        add_to_db(key, values)
      end

      def on_broadcast(service_name, event_name)
        service_data = find(service_name, event_name)
        delete(service_name)
        service_data
      end

      def insert_service_data(key, *values)
        add_to_db(key, values)
      end

      def insert(key, *values)
        add_to_db(key, values)
      end

      def findall(key)
        @db.keys(key)
      end

      def on_triggered(global_key, finding_key)
        find(global_key, finding_key)
      end

      def find2(global_key, finding_key)
        find(global_key, finding_key)
      end

      def find3(global_key, finding_key)
        find(global_key, finding_key)
      end

      def find(global_key, finding_key)
        result = @db.hget(global_key, finding_key)
        # byebug
        Marshal.load(result) unless result.nil?
      end

      def delete(service_name)
        @db.del(service_name)
      end

      private

      def add_to_db(key, values)
        @db.hmset(key, values.map.with_index { |val, ind| (ind.even? ? val : Marshal.dump(val)) })
      end
    end
  end
end
