require 'singleton'
require 'redis'
require 'json'

module Storage
  class Redis
    include Singleton

    def initialize
      @db = ::Redis.new
    end
    
    def insert(key, value)
      @db.set(key, value.to_json) 
    end

    def find(key)
      JSON.parse @db.get(key)
    end

    def add(global_key, key, value)
      @db.hmset(global_key, key, value)     
    end

    def find_where(global_key, finding_key)
      @db.hget(global_key, finding_key)      
    end
  end
end