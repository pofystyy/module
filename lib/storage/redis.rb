require_relative 'base_storage'
require 'singleton'
require 'redis'
require 'byebug'

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
      @db.keys("#{key}.*")
    end

    def on_triggered(global_key, finding_key)
      find(global_key, finding_key)
    end

    def find(global_key, finding_key)
      info = @db.hget(global_key, finding_key)
      Marshal.load(info) unless info.nil?
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
