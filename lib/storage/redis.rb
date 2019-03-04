require 'redis'
require 'json'

module Storage
  class Redis
    def self.db
      ::Redis.new
    end
    
    def self.insert(key, value)
      db.set(key, value.to_json) 
    end

    def self.find(key)
      JSON.parse db.get(key)
    end
  end
end