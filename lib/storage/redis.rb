require 'singleton'
require 'redis'
require 'json'

module Storage
  class Redis
    include Singleton

    def initialize
      @db = ::Redis.new
    end

    def insert(key, *value)
      @db.hmset(key, value.each { |v| v })    
    end

    def find(global_key, finding_key)  
      @db.hget(global_key, finding_key)
    end
  end
end