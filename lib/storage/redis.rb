require_relative 'base_storage'
require 'singleton'
require 'redis'

module Storages
  class Redis < BaseStorage
    include Singleton

    def initialize
      @db = ::Redis.new
    end

    def trigger(service_name, method = nil)
      [find(service_name, 'class'), find(service_name, 'methods')]
    end

    def on(service_name, event_name)
      find(service_name, event_name)
    end

    def insert(key, *values)
      @db.hmset(key, values.each { |v| v })    
    end

    private

    def find(global_key, finding_key)  
      @db.hget(global_key, finding_key)
    end
  end
end