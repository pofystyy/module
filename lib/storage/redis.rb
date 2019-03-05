require 'redis'
require 'json'

module Storage
  class Redis

    @@db = ::Redis.new
    
    def self.insert(key, value)
      @@db.set(key, value.to_json) 
    end

    def self.find(key)
      JSON.parse @@db.get(key)
    end

    # def self.add(global_key, key, value)
    #   @@db.hmset(global_key, value, key)     
    # end

    # def self.find_where(global_key, finding_key)
    #   @@db.hget(global_key, finding_key)      
    # end
  end
end