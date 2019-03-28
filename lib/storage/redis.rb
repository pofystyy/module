require_relative 'base_storage'
require 'singleton'
require 'redis'

module Storages
  class Redis < BaseStorage
    include Singleton

    def initialize
      @db = ::Redis.new
    end

    def trigger(service_name)
      [find(service_name, 'class'), find(service_name, 'methods')]
    end

    def on(service_name, event_name)
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

    private  

    def find(global_key, finding_key)  
      @db.hget(global_key, finding_key)
    end

    def add_to_db(key, values)
      @db.hmset(key, values.each { |v| v })    
    end 

    def delete(service_name)
      @db.del(service_name)
    end
  end
end