require 'redis'
require 'json'

class Storage
  def initialize
    @db = Redis.new
  end

  def insert(key, value)
    @db.set(key, value.to_json) 
  end

  def find(key)
    JSON.parse @db.get(key)
  end
end